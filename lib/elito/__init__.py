#

_orig_decode = None

def get_alternate_dir(base, suffix):
    if not base.endswith(suffix) or os.path.exists(base):
        return False

    tmp = base[:-len(suffix)]
    if os.path.exists(tmp):
        return tmp

    return base

def proto_decodeurl(url):
    res = _orig_decode(url)
    #bb.warn("%s -> %s" % (url, res))

    scheme = res[0]
    if scheme.startswith('git+'):
        res = list(res)
        protocol = scheme[4:]

        res[0] = 'git'
        res[5]['protocol'] = protocol

        if protocol == 'file':
                res[2] = get_alternate_dir(res[2], '.git')

    return tuple(res)

def enhance_decodeuri():
    global _orig_decode

    if _orig_decode == None:
        _orig_decode = bb.fetch.decodeurl
        bb.fetch.decodeurl = proto_decodeurl
