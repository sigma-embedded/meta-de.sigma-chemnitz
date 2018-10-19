import fnmatch
import pipes
import oe
import oe.data
import bb.parse
import errno

def prepare(d):
    class copy_info:
        def __init__(self, topdir, mode):
            self.topdir = os.path.normpath(topdir)
            self.content = []
            self.dirs = []
            self.lnks = []
            self.mode = mode

        def __get_path(self, data, absolute):
            if absolute:
                return map(lambda x: (x, os.path.join(self.topdir, x)), data)
            else:
                return data

        def get_dirs(self, absolute = False):
            return self.__get_path(self.dirs, absolute)

        def get_lnks(self, absolute = False):
            return self.__get_path(self.lnks, absolute)

        def get_content(self, absolute = False):
            return self.__get_path(self.content, absolute)

        def tar_opt(self, is_shell = False):
            res = [ '-C', self.topdir, '--mode', mode,
                    '--no-recursion',
                    '--owner', 'root', '--group', 'root' ]
            res.extend(self.get_content(False))
            res.extend(self.get_lnks(False))
            res.extend(self.get_dirs(False))

            #bb.warn("RES: %s" % (res,))
            if is_shell:
                return ' '.join(map(lambda x: pipes.quote(x), res))
            else:
                return res

    def __filtered(fname, patterns):
        for p in patterns:
            if fnmatch.fnmatch(fname, p):
                return True

        return False

    def __fn(arg, dirname, fnames):
        info = arg[0]
        patterns = arg[1]

        for i in range(len(fnames), 0, -1):
            if __filtered(fnames[i-1], patterns):
                del fnames[i-1]

        tmp = set(fnames[:])

        lnks = set(filter(lambda x: os.path.islink(os.path.join(dirname, x)),
                          tmp))
        tmp = tmp - lnks

        dirs = set(filter(lambda x: os.path.isdir(os.path.join(dirname, x)),
                          tmp))
        tmp = tmp - dirs

        d = dirname[len(info.topdir)+1:]

        info.content.extend(map(lambda x: os.path.join(d, x), tmp))
        info.dirs.extend(map(lambda x: os.path.join(d, x), dirs))
        info.lnks.extend(map(lambda x: os.path.join(d, x), lnks))

    ############

    here = d.getVar('THISDIR', True)
    mode = d.getVar('ELITO_COPY_MODE', True)
    content = map(lambda x: copy_info(os.path.join(here, x), mode),
                  oe.data.typed_value('ELITO_COPY_TOPDIRS', d))
    patterns = set(oe.data.typed_value('ELITO_COPY_IGNORE_PATTERN', d))

    try:
        import hashlib
        m = hashlib.md5()
    except ImportError:
        import md5
        m = md5.new()

    for c in content:
        if not os.path.isdir(c.topdir):
            raise OSError(errno.ENOENT,
                          'ELITO_COPY_TOPDIRS: no such directory %s' % c.topdir)

        for root, dirs, files in os.walk(c.topdir + os.path.sep):
            __fn([c, patterns], root, dirs + files)

        c.dirs.sort()
        c.lnks.sort()
        c.content.sort()

        bb.parse.mark_dependency(d, c.topdir)

        for (rel,f) in c.get_dirs(True):
            #bb.warn("DIR: %s" % f)
            bb.parse.mark_dependency(d, f)

        for (rel,f) in c.get_lnks(True):
            #bb.warn("LNK: %s" % f)
            m.update(rel)
            m.update(os.readlink(f))

        for (rel,f) in c.get_content(True):
            #bb.warn("REG: %s" % f)
            bb.parse.mark_dependency(d, f)
            m.update(rel)
            m.update("%u" % bb.parse.cached_mtime(f))

    res = [m.hexdigest(), content]
    #bb.info("==> %s" % (res,))

    return res
