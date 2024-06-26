## SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
##
## OE part of the sstate-server server
##
## https://gitlab-ext.sigma-chemnitz.de/ensc/sstate-server
##

from abc import ABC, abstractmethod
import bb
import os
import time
import json
import oe.data

## delay in seconds between two pings
PING_DELAY = 120
last_ping = time.monotonic() - PING_DELAY

sstate_server_disabled = False
upload_disabled = -1
start_tm = None

class Connection:
    def __init__(self, conn, uri):
        self.__conn = conn
        self.__uri = uri

    def __enter__(self):
        return (self.__conn, self.__uri)

    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.__conn.close()

## Generic object with some helper functions
class SStateAPI(ABC):
    @staticmethod
    def connect(d, api):
        """Generate URI to the given API endpoint and connect to the server.
        Do *not* send the HTTP request itself yet."""
        import http.client
        from urllib.parse import urlparse

        uri = d.expand('${SSTATE_SERVER_API}' + api)
        uri = urlparse(uri)

        if uri.scheme == "http":
            conn = http.client.HTTPConnection(uri.hostname, uri.port)
        elif uri.scheme == "https":
            conn = http.client.HTTPSConnection(uri.hostname, uri.port)
        else:
            bb.warn("Unsupported scheme '%s' for sstate-server" % (uri.scheme))
            raise Exception("unsupported upload scheme '%s'" % (uri.scheme))

        return Connection(conn, uri)

    @staticmethod
    def is_enabled(d):
        """Return whether sstate-server is available. It depends on some
        environment variables and can be disabled globally."""
        global sstate_server_disabled

        if sstate_server_disabled:
            return False
        elif (d.getVar('SSTATE_SERVER_API') or "").strip() == "":
            return False
        elif oe.data.typed_value('SSTATE_SERVER_DISABLED', d):
            return False
        else:
            return True

    @staticmethod
    def get_session(d):
        """Returns the session id for pull requests."""
        session = d.getVar('SSTATE_SERVER_SESSION', True)
        if not session or session == "":
            bb.debug(2, "sstate-server session not available")
            return None

        return session

    def _precheck(self, d):
        """Return whether API function should be called.  Can be overridden by
        subclasses."""
        return True

    def _postfunc(self, d, res):
        """Evaluate the response when API call succeeded.  Generally,
        this will update the keep-alive timer but can be overridden by
        subclasses."""
        global last_ping
        last_ping = time.monotonic()

    @abstractmethod
    def _report_error(self, e):
        """Report errors when API call failed.  It must be overridden by
        subclasses."""
        pass

    @abstractmethod
    def _run(self, d, session):
        """Fill parameters and call the API functions.  It must be overridden
        by subclasses."""
        pass

    @abstractmethod
    def _op(self):
        """Returns textual description of acutal function.  Must by overridden
        by subclasses."""
        pass

    def _generic_403(self, res):
        if res.status != 403:
            return

        global sstate_server_disabled

        ## TODO: this does not work; 'd' (and module global
        ## variables) are not shared between recipes

        bb.note("unauthorized; disabling sstate-server globally")
        d.setVar('SSTATE_SERVER_DISABLED', 'true')
        sstate_server_disabled = True

    def run(self, d):
        """Executes the API subcall.  Function will check whether function
        should be called, gets the session and calls the internal
        _run() function then."""
        if not self._precheck(d):
            return

        session = self.get_session(d)
        if not session:
            return

        try:
            res = self._run(d, session)

            if res.status != 304 and (res.status < 200 or res.status > 299):
                raise Exception("%s: failed with code: %s" % (self._op(), res.status))

            self._postfunc(d, res)
        except Exception as e:
            self._report_error(e)

## Issues a 'ping' to keep the session alive
class Ping(SStateAPI):
    def __init__(self):
        super()

    def _op(self):
        return "ping"

    def _precheck(self, d):
        global last_ping
        return last_ping + PING_DELAY < time.monotonic()

    def _report_error(self, d):
        ## TODO: not implemented yet at server site; skip warnings
        #bb.warn("failed to ping sstate server: %s" % (e,))
        pass

    def _run(self, d, session):
        with self.connect(d, "/v1/session/ping") as (conn, uri):
            hdrs = {
                "x-session"        : session,
            }

            conn.request('GET', url = uri.path, headers = hdrs)

            res = conn.getresponse()
            self._generic_403(res)

            return res

## Transmits some metadata
class SetInfo(SStateAPI):
    def __init__(self):
        super()

    def _op(self):
        return "set-info"

    def _report_error(self, e):
        ## TODO: not implemented yet at server site; skip warnings
        #bb.warn("failed to set sstate information: %s" % (e,))
        pass

    def _run(self, d, session):
        with self.connect(d, "/v1/session/set-info") as (conn, uri):
            distro = (d.getVar("DISTRO_CODENAME", True) or
                      (d.getVar('LAYERSERIES_CORENAMES', True).split() or [None])[-1])

            hdrs = {
                "x-session"   : session,
                "x-lsb"       : d.getVar("NATIVELSBSTRING", True),
                "x-corename"  : distro,
            }

            conn.request('PATCH', url = uri.path, headers = hdrs)
            return conn.getresponse()

## Fetches stats and displays them
class Stats(SStateAPI):
    def __init__(self):
        super()
        pass

    def _op(self):
        return "stats"

    def _postfunc(self, d, res):
        super()._postfunc(d, res)
        ## TODO: emit stats

    def _report_error(self, e):
        ## TODO: not implemented yet at server site; skip warnings
        #bb.warn("failed to get session stats from sstate server: %s" % (e,))
        pass

    def _run(self, d, session):
       with self.connect(d, "/v1/session/stats") as (conn, uri):
           hdrs = {
               "x-session"        : session,
           }

           conn.request('GET', url = uri.path, headers = hdrs)
           return conn.getresponse()

## Uploads a file
class Upload(SStateAPI):
    def __init__(self, ftype, fname, path, scmrev = None, tags = None,
                 is_signed = False, task = None):
        super()
        self.ftype     = ftype
        self.fname     = fname
        self.path      = path
        self.scmrev    = None
        self.tags      = None
        self.task      = task
        self.is_signed = is_signed

    @staticmethod
    def is_enabled(d):
        if not SStateAPI.is_enabled(d):
            return False

        global upload_disabled

        if upload_disabled != -1:
            return not upload_disabled

        session = Upload.get_session(d)
        if not session:
            return

        with Upload.connect(d, "/v1/session/disable/push") as (conn, uri):
            hdrs = {
                "x-session"        : session
            }

            conn.request('GET', url = uri.path, headers = hdrs)

            res = conn.getresponse()
            if res.status != 200:
                # no api support
                bb.debug(0, "sstate does not support filter query yet; assuming that upload is enabled")
                upload_disabled = False
            else:
                try:
                    res = res.read().decode('utf-8')
                    res = json.loads(res)
                    upload_disabled = res == True
                    bb.note("upload_disabled detected as %s" % upload_disabled)
                except Exception as e:
                    bb.warn("failed to parse filter query response (%s); assuming that upload is enabled: %s" % (res, e))
                    upload_disabled = False

        return not upload_disabled

    @staticmethod
    def _skip_file(dl_dir, fname):
        global start_tm

        ## TOOD: this method is hacky;

        path      = os.path.join(dl_dir, fname)
        done_file = path + ".done"

        ## master file
        try:
            st = os.stat(done_file)
        except:
            bb.warn("source %s does not exist; skipping" % (fname,))
            return True

        if st.st_size == 0:
            bb.debug(1, "%s file is empty; skipping" % (fname,))
            return True

        ## "done" marker file
        try:
            st = os.lstat(done_file)
        except:
            bb.warn("%s.done file does not exist; skipping" % (done_file,))
            return True

        if st.st_mtime < start_tm:
            bb.debug(1, "%s.done file created before actual session; skipping" % (fname,))
            return True

        return False

    @staticmethod
    def from_srcuri(d, uri, ud):
        info = None

        ## TODO: what are the semantics of 'mirrortarballs'?  Can
        ## there be multiple ones?

        if (isinstance(ud.method, bb.fetch2.local.Local) or
            isinstance(ud.method, bb.fetch2.npmsw.NpmShrinkWrap)):
            ## do not upload local file:// resources or npmsw://
            pass
        elif (isinstance(ud.method, bb.fetch2.git.Git) or
              isinstance(ud.method, bb.fetch2.hg.Hg)):
            if ud.parm.get("protocol", None) in ["file"]:
                ## do not upload scm from git+file://
                pass
            elif ud.write_tarballs:
                info = ('scm', ud.mirrortarballs)
        elif isinstance(ud.method, bb.fetch2.npm.Npm):
            # TODO: use 'npm' instead of 'source' when server support
            # is available; filenames might conflict with regular
            # sources else
            info = ('source', [os.path.join("npm2", os.path.basename(ud.localpath))])
        else:
            info = ('source', [os.path.basename(ud.localpath)] )

        if not info:
            return []

        dl_dir = d.getVar("DL_DIR")
        files  = filter(lambda u: not Upload._skip_file(dl_dir, u),
                        info[1])

        res = map(lambda u: Upload(ftype  = info[0],
                                   fname  = os.path.basename(u),
                                   path   = os.path.join(dl_dir, u),
                                   scmrev = getattr(ud, 'revision', None)),
                  files)

        return list(res)

    def _op(self):
        return "upload"

    def _postfunc(self, d, res):
        bb.note("uploaded %s (%s type) to sstate-server" % (self.fname, self.ftype))
        super()._postfunc(d, res)

    def _report_error(self, e):
        bb.warn("failed to upload %s file %s: %s" % (self.ftype, self.fname, e))

    def _run(self, d, session):
        with self.connect(d, "/v1/upload/" + self.ftype) as (conn, uri):
            with open(self.path, "rb") as f:
                st = os.fstat(f.fileno())

                hdrs = {
                    "content-length"   : "%s" % st.st_size,
                    "cache-control"    : "no-store",
                    "x-session"        : session,
                    "x-pkg-pn"         : d.getVar("PN", True),
                    "x-pkg-pv"         : d.getVar("PV", True),
                    "x-pkg-pr"         : d.getVar("PR", True),
                    "x-pkg-pe"         : d.getVar("PE", True),
                    "x-pkg-scmrev"     : self.scmrev,
                    "x-ftime"          : "%s" % st.st_mtime,
                    "x-filename"       : self.fname,
                    "x-task"           : self.task,
                    "x-is-signed"      : ["nil", "t"][self.is_signed],
                }

                # filter out empty values
                hdrs = { k: v   for k, v in hdrs.items() if v is not None and v != "" }

                conn.request('PUT', url = uri.path, body = f, headers = hdrs)

            res = conn.getresponse()

            return res

## TODO: use 'eventmask' to filter for bb.event.TaskSucceeded instead
## of comparing it manually
def handle_event(e):
    global start_tm

    if isinstance(e, bb.event.ConfigParsed):
        # this must be done in an early event; else 'e.data' is local
        # and not carried to other events
        e.data.setVarFlag('_SSTATE_SERVER_INFO', 'start_time', time.time())

    elif isinstance(e, bb.event.BuildStarted):
        SetInfo().run(e.data)

    elif isinstance(e, bb.event.HeartbeatEvent):
        Ping().run(e.data)

    elif isinstance(e, bb.event.BuildCompleted):
        Stats().run(e.data)

    elif isinstance(e, bb.build.TaskSucceeded):
        start_tm = e.data.getVarFlag('_SSTATE_SERVER_INFO', 'start_time')
        assert(start_tm != None)

        if e.task in (e.data.getVar('SSTATETASKS') or "").split():
            post_create(e.data, e.task)

        if e.task == "do_fetch":
            post_fetch(e.data)

def post_fetch(d):
    if not Upload.is_enabled(d):
        return

    src_uris = (d.getVar('SRC_URI', True) or "").split()
    fetcher = bb.fetch2.Fetch(src_uris, d)

    for (uri, ud) in fetcher.ud.items():
        uploads = Upload.from_srcuri(d, uri, ud)

        for u in uploads:
            u.run(d)

## function is part of SSTATEPOSTCREATEFUNCS and called after creating
## the sstate file and (optionally) its signature, but *before* the
## .siginfo file is there
def post_create(d, task = None):
    import tempfile

    if d.getVar('SSTATE_SKIP_CREATION') == '1':
        return

    if not Upload.is_enabled(d):
        return

    is_signed = not not d.getVar('SSTATE_SIG_KEY')

    # unfortunately, only ${SSTATE_PKG} contains the correct path but
    # not SSTATE_PKGNAME.  Strip away the ${SSTATE_DIR} to generate
    # the filename
    sstate_dir     = d.expand("${SSTATE_DIR}/", True)
    sstate_pkg     = d.getVar("SSTATE_PKG", True)
    sstate_pkgname = sstate_pkg[len(sstate_dir):]

    Upload(ftype     = 'sstate',
           fname     = sstate_pkgname,
           path      = sstate_pkg,
           scmrev    = None,
           tags      = None,
           task      = task,
           is_signed = is_signed).run(d)

    if is_signed:
        Upload(ftype     = 'sstate',
               fname     = sstate_pkgname + ".sig",
               path      = sstate_pkg + ".sig",
               scmrev    = None,
               tags      = None,
               task      = task,
               is_signed = is_signed).run(d)

    ## TODO: generating .siginfo here is hacky...  the .siginfo file
    ## will be created *after* calling SSTATEPOSTCREATEFUNCS
    ##
    ## TODO: we are calling this from an eventhandler now... remove
    ## manual generation
    with tempfile.NamedTemporaryFile() as f:
        path = sstate_pkg + ".siginfo"
        if not os.path.isfile(path):
            bb.siggen.dump_this_task(f.name, d)
            path = f.name

        Upload(ftype     = 'sstate',
               fname     = sstate_pkgname + ".siginfo",
               path      = path,
               scmrev    = None,
               tags      = None,
               task      = task,
               is_signed = is_signed).run(d)
