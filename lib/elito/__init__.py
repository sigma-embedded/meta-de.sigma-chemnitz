#

_orig_decode = None
_orig_class = None

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

class URI(bb.fetch.URI):
    def __init__(self, uri=None):
        orig_uri = uri
        if uri is None:
            protocol = None
        else:
            (uri,protocol) = URI.__decodeurl(uri)

        super().__init__(uri)

        if protocol is not None:
            self.params['protocol'] = protocol
            bb.debug(1, "plus-uri: %s -> %s" % (orig_uri, self))

    @staticmethod
    def __decodeurl(uri):
        import urllib.parse

        raw_uri, param_str = (uri.split(";", 1) + [None])[:2]
        urlp = urllib.parse.urlparse(raw_uri)

        (scheme, protocol) = (urlp.scheme.split('+', 1) + [None, None])[:2]

        if protocol is not None:
            urlp = list(urlp)
            urlp[0] = scheme

            if protocol == 'file':
                urlp[2] = get_alternate_dir(urlp[2], '.git')

            uri = urllib.parse.urlunparse(urlp)
            if param_str:
                uri += ";" + param_str

        return (uri, protocol)

def enhance_decodeuri():
    global _orig_decode
    global _orig_class

    if _orig_decode == None:
        _orig_decode = bb.fetch.decodeurl
        bb.fetch.decodeurl = proto_decodeurl

    if _orig_class == None:
        _orig_class = bb.fetch.URI
        bb.fetch.URI = URI
