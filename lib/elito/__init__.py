#

_orig_decode = None

def get_alternate_dir(base, suffix):
    if not base.endswith(suffix) or os.path.exists(base):
        return base

    tmp = base[:-len(suffix)]
    if os.path.exists(tmp):
        return tmp

    return base

def proto_decodeurl(url):
    res = _orig_decode(url)
    #bb.warn("%s -> %s" % (url, res))

    (scheme, protocol) = (res[0].split('+', 1) + [None, None])[:2]

    if protocol is not None:
        res = list(res)

        res[0] = scheme
        res[5]['protocol'] = protocol

        if protocol == 'file':
                res[2] = get_alternate_dir(res[2], '.git')

        #bb.note("%s -> %s" % (url, res))

    return tuple(res)

def enhance_decodeuri():
    global _orig_decode

    if _orig_decode == None:
        _orig_decode = bb.fetch.decodeurl
        bb.fetch.decodeurl = proto_decodeurl
