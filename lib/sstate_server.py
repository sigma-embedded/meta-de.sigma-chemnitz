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
import oe.data

## delay in seconds between two pings
PING_DELAY = 120
last_ping = time.monotonic() - PING_DELAY

sstate_server_disabled = False
start_tm = None

## Generic object with some helper functions
class SStateAPI(ABC):
    def connect(self, d, api):
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

        return (conn, uri)

    @staticmethod
    def is_enabled(d):
        """Return whether sstate-server is available. It depends on some
        environment variables and can be disabled globally."""
        global sstate_server_disabled

        if sstate_server_disabled:
            return False
        elif (d.getVar('SSTATE_SERVER_API', True) or "").strip() == "":
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
        (conn, uri) = self.connect(d, "/v1/session/ping")

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
        (conn, uri) = self.connect(d, "/v1/session/set-info")

        hdrs = {
            "x-session"   : session,
            "x-lsb"       : d.getVar("NATIVELSBSTRING", True),
            "x-oerev"     : d.getVar("LAYERSERIES_CORENAMES", True),
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
       (conn, uri) = self.connect(d, "/v1/session/stats")

       hdrs = {
           "x-session"        : session,
       }

       conn.request('GET', url = uri.path, headers = hdrs)
       return conn.getresponse()

## Uploads a file
class Upload(SStateAPI):
    def __init__(self, ftype, fname, path, scmrev = None, tags = None,
                 is_signed = False):
        super()
        self.ftype     = ftype
        self.fname     = fname
        self.path      = path
        self.scmrev    = None
        self.tags      = None
        self.is_signed = is_signed

    @staticmethod
    def from_srcuri(uri, ud):
        info = None

        ## TODO: what are the semantics of 'mirrortarballs'?  Can
        ## there be multiple ones?

        if isinstance(ud.method, bb.fetch2.local.Local):
            ## do not upload local file:// resources
            pass
        elif (isinstance(ud.method, bb.fetch2.git.Git) or
              isinstance(ud.method, bb.fetch2.hg.Hg) or
              isinstance(ud.method, bb.fetch2.npm.Npm)):
            if ud.parm.get("protocol", None) in ["file"]:
                ## do not upload scm from git+file://
                pass
            elif ud.write_tarballs:
                info = ('scm', ud.mirrortarballs)
        else:
            info = ('source', [os.path.basename(ud.localpath)] )

        if not info:
            return []

        res = map(lambda u: Upload(ftype  = info[0],
                                   fname  = u,
                                   path   = os.path.join(d.getVar("DL_DIR", True), u),
                                   scmrev = getattr(ud, 'revision', None)),
                  info[1])

        return list(res)

    def _op(self):
        return "upload"

    def _postfunc(self, d, res):
        bb.note("uploaded %s (%s type) to sstate-server" % (self.fname, self.ftype))
        super()._postfunc(d, res)

    def _report_error(self, e):
        bb.warn("failed to upload %s file %s: %s" % (self.ftype, self.fname, e))

    def _run(self, d, session):
        (conn, uri) = self.connect(d, "/v1/upload/" + self.ftype)

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

    elif isinstance(e, bb.build.TaskProgress):
        Ping().run(e.data)

    elif isinstance(e, bb.event.BuildCompleted):
        Stats().run(e.data)

    elif isinstance(e, bb.build.TaskSucceeded):
        start_tm = e.data.getVarFlag('_SSTATE_SERVER_INFO', 'start_time', True)
        assert(start_tm != None)

        if e.task in (e.data.getVar('SSTATETASKS', True) or "").split():
            post_create(e.data)

        if e.task == "do_fetch":
            post_fetch(e.data)

def post_fetch(d):
    if not Upload.is_enabled(d):
        return

    src_uris = (d.getVar('SRC_URI', True) or "").split()
    fetcher = bb.fetch2.Fetch(src_uris, d)

    for (uri, ud) in fetcher.ud.items():
        uploads = Upload.from_srcuri(uri, ud)

        for u in uploads:
            u.run(d)

## function is part of SSTATEPOSTCREATEFUNCS and called after creating
## the sstate file and (optionally) its signature, but *before* the
## .siginfo file is there
def post_create(d):
    import tempfile

    if d.getVar('SSTATE_SKIP_CREATION', True) == '1':
        return

    if not Upload.is_enabled(d):
        return

    is_signed = not not d.getVar('SSTATE_SIG_KEY', True)

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
           is_signed = is_signed).run(d)

    if is_signed:
        Upload(ftype     = 'sstate',
               fname     = sstate_pkgname + ".sig",
               path      = sstate_pkg + ".sig",
               scmrev    = None,
               tags      = None,
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
               is_signed = is_signed).run(d)
