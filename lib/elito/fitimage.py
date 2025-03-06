from abc import ABC, abstractmethod
from functools import cmp_to_key
import os.path

class FitSignature:
    def __init__(self, hash_algo = "sha256", ):
        self.hash_algo = hash_algo
        self.signatures = []

    def add_key(self, hint, sign_algo = "sha256,rsa2048"):
        self.signatures.append((hint, sign_algo))

    def add_hash(self, node):
        node.add_node(OfNode("hash-1", None)
                      .add_prop_string("algo", self.hash_algo))

    def add_hash_sign(self, node):
        self.add_hash(node)

        idx = 1
        for (hint, algo) in self.signatures:
            node.add_node(OfNode("signature-%d" % idx, None)
                          .add_prop_string("algo", algo)
                          .add_prop_string('key-name-hint', hint))
            idx += 1

class OfValue:
    def __init__(self, val):
        self.val = val

    def emit(self, d, as_raw = False):
        assert(d is not None)
        v = d.expand(self.val)
        return self._emit(v, as_raw = as_raw)

    @abstractmethod
    def _emit(self, v, as_raw = False):
        assert(False)

class OfValueList(OfValue):
    def __init__(self, v = []):
        super().__init__(v[:])

    def push(self, prop):
        assert(isinstance(prop, OfValue))
        self.val.append(prop)

    def emit(self, d, as_raw = False):
        assert(d is not None)
        return ', '.join([p.emit(d, as_raw) for p in self.val])

class OfValueNodeName(OfValue):
    def __init__(self, val):
        assert(isinstance(val, OfNode))
        super().__init__(val)

    def emit(self, d, as_raw = False):
        assert(d is not None)
        v = d.expand(self.val.get_name(d))
        return self._emit(v, as_raw = as_raw)

    def _emit(self, v, as_raw = False):
        if as_raw:
            return "%s" % v
        else:
            return '"%s"' % v

class OfValueBool(OfValue):
    def __init__(self, val = None):
        assert(val is None);
        super().__init__(val)

class OfValueString(OfValue):
    def __init__(self, val):
        super().__init__(val)

    def _emit(self, v, as_raw = False):
        if as_raw:
            return "%s" % v
        else:
            return '"%s"' % v

class OfValueH32(OfValue):
    def __init__(self, val):
        super().__init__(val)

    def _emit(self, v, as_raw = False):
        if as_raw:
            return '0x%08x' % v
        else:
            return '<0x%08x>' % v

class OfValueI32(OfValue):
    def __init__(self, val):
        super().__init__(val)

    def _emit(self, v, as_raw = False):
        if as_raw:
            return "%d" % v
        else:
            return '<%d>' % v

class OfValueIncBin(OfValue):
    def __init__(self, val):
        super().__init__(val)

    def _emit(self, v, as_raw = False):
        assert(not as_raw)
        return '/incbin/("%s")' % v

class OfProperty:
    def __init__(self, key, val):
        assert(val is None or isinstance(val, OfValue))
        self.key = key
        self.val = val

    def emit(self, d):
        if self.val is not None:
            return "%s = %s;" % (self.key, self.val.emit(d))
        else:
            return "%s;" % (self.key,)

    def emit_val(self, d, as_raw = False):
        return self.val.emit(d, as_raw)

class OfPropertyString(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, OfValueString(val))

class OfPropertyH32(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, OfValueH32(val))

class OfPropertyI32(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, OfValueI32(val))

class OfPropertyIncBin(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, OfValueIncBin(val))

class OfPropertyDelete:
    def __init__(self, op, key):
        self.op  = op
        self.key = key

    def emit(self, d):
        return "/%s/ %s;" % (self.op, self.key)

class OfNode:
    def __init__(self, name, instance = None, pseudo_reg = False):
        self.name = name
        self.instance = instance
        self._pseudo_reg = pseudo_reg
        self._props = []
        self._nodes = []
        self._instance_prop = None

    def add_prop(self, prop):
        self._props.append(prop)
        return self

    def add_prop_string(self, key, val):
        return self.add_prop(OfPropertyString(key, val))

    def add_prop_h32(self, key, val):
        return self.add_prop(OfPropertyH32(key, val))

    def add_prop_i32(self, key, val):
        return self.add_prop(OfPropertyI32(key, val))

    def add_node(self, node):
        self._nodes.append(node)
        return self

    def get_name(self, d):
        if self._instance_prop is None:
            return d.expand(self.name)
        else:
            return d.expand("%s%s%s" % (
                self.name,
                ['@', '-'][self._pseudo_reg],
                self._instance_prop.emit_val(d, as_raw = True)))

    def attr_map(self, attrs):
        res = []
        for (val, attr, klass) in attrs:
            if val is None:
                continue

            self.add_prop(klass(attr, val))

        return res

    def finish(self):
        if self.instance is not None:
            self._instance_prop = OfPropertyH32("reg", self.instance)

            if not self._pseudo_reg:
                self.add_prop(self._instance_prop)

        for n in self._nodes:
            n.finish()

        return self

    @staticmethod
    def indent(data):
        return map(lambda x: ('\t%s' % x).rstrip(), data)

    def emit(self, d):
        res = []

        res.append(self.get_name(d) + ' {')

        props = []
        for p in filter(lambda x: x.key.startswith('#'), self._props):
            props.append(p.emit(d))

        for p in filter(lambda x: not x.key.startswith('#'), self._props):
            props.append(p.emit(d))

        nodes = []
        for n in self._nodes:
            nodes.extend(n.emit(d))

        res.extend(self.indent(props))
        if props and nodes:
            res.append("")
        res.extend(self.indent(nodes))

        res.append("};")

        return res

class OfTree:
    def __init__(self):
        self._nodes = []

    def add_node(self, node):
        self._nodes.append(node)
        return self

    def finish(self):
        for n in self._nodes:
            n.finish()
        return self

    def emit(self, d):
        res = [
            "/dts-v1/;",
        ]

        for n in self._nodes:
            res.append("")
            res.extend(n.emit(d))

        return '\n'.join(res)

##

class FitImage(OfNode):
    def __init__(self):
        super().__init__("/")

        self.description = "U-Boot fitImage for ${DISTRO_NAME}/${PV}/${MACHINE}"

    def finish(self):
        self.add_prop_string("description", self.description)
        return super().finish()

    @staticmethod
    def get_hwid(dtb, id_attr, desc_attr):
        import subprocess
        with subprocess.Popen(["fdtget", dtb, "/", id_attr], stdout = subprocess.PIPE) as proc:
            data_id = proc.stdout.readline().strip()
        with subprocess.Popen(["fdtget", dtb, "/", desc_attr], stdout = subprocess.PIPE) as proc:
            data_desc = proc.stdout.readline().strip()

        if not data_id:
            return None

        return (int(data_id), data_desc.decode())

    @staticmethod
    def from_desc(kernels = [], dtbs = [], overlays = [], ramdisks = [],
                  id_attr = "device-id", desc_attr = "device-description",
                  cfgnode = None, cfg_ramdisks = [], cfg_overlays = [],
                  signature = FitSignature()):
        images = OfNode("&images")

        if len(dtbs) != 1 and cfgnode and cfg_overlays:
            raise Exception("overlays can be add to cfg only with a single dtb")

        dtb_map = {}
        rd_map = {}
        fdt_ids = {}

        idx    = 0
        for k in kernels:
            images.add_node(FitPart("kernel", idx)
                            .set_inputfile(k))

        for d in dtbs + overlays:
            (hw_id, hw_desc) = FitImage.get_hwid(d, id_attr, desc_attr) or (0, d)
            part = (FitPart("fdt", signature, hw_id)
                    .set_type("flat_dt")
                    .set_compression("none")
                    .set_description(hw_desc)
                    .set_inputfile(d))
            images.add_node(part)
            dtb_map[d] = part

        idx = 0
        for r in ramdisks:
            part = (FitPart("ramdisk", signature, idx)
                    .set_os("linux")
                    .set_compression("none")
                    .set_inputfile(r))
            images.add_node(part)
            rd_map[r] = part

        cfg = []

        if cfgnode:
            cfg = OfNode(cfgnode)

            if cfg_ramdisks:
                p = OfValueList()
                for rd in cfg_ramdisks:
                    p.push(OfValueNodeName(rd_map[rd]))
                cfg.add_prop(OfProperty('ramdisk', p))

            if cfg_overlays or dtbs:
                p = OfValueList()
                for ov in dtbs + cfg_overlays:
                    p.push(OfValueNodeName(dtb_map[ov]))
                cfg.add_prop(OfProperty('fdt', p))

            signature.add_hash_sign(cfg)

        cfg_root = OfNode("/")
        cfg_conf = OfNode("configurations")

        for d in overlays:
            part = dtb_map[d]
            cfg_conf.add_node(FitOverlayConfNode('overlay', signature, part))

        cfg_root.add_node(cfg_conf)

        return (images, cfg, cfg_root)

class FitNode(OfNode):
    def __init__(self, name, instance):
        super().__init__(name, instance, True)

class FitOverlayConfNode(FitNode):
    def __init__(self, prefix, signature, part):
        super().__init__(prefix, part.instance)
        self.part = part
        self.signature = signature

    def finish(self):
        part = self.part

        self.add_prop(OfProperty('fdt', OfValueNodeName(part)))
        self.add_prop_string('description', part.desc);

        self.signature.add_hash_sign(self)

        return super().finish()

class FitPart(FitNode):
    def __init__(self, type, signature, instance = None):
        super().__init__(type, instance)

        self.type = type
        self.name = type
        self.__data = None
        self.desc = None
        self.arch = "${ARCH}"
        self.compression = None
        self.signature = signature
        self.entry = None
        self.load = None
        self.os = None

    def set_compression(self, comp):
        self.compression = comp
        return self

    def set_os(self, os):
        self.os = os
        return self

    def set_load(self, load):
        self.load = load
        return self

    def set_entry(self, entry):
        self.entry = entry
        return self

    def set_description(self, desc):
        self.desc = desc
        return self

    def set_type(self, type):
        self.type = type
        return self

    def set_inputfile(self, fname):
        if self.desc is None:
            self.desc = os.path.basename(fname)

        if self.compression is None:
            if fname.endswith(".gz"):
                self.compression = "gzip"

        self.__data = OfPropertyIncBin("data", fname)

        return self

    def finish(self):
        assert(self.__data is not None)

        self.add_prop(self.__data)

        self.attr_map([
            (self.type,  "type",              OfPropertyString),
            (self.desc, "description",        OfPropertyString),
            (self.arch, "arch",               OfPropertyString),
            (self.os,   "os",                 OfPropertyString),
            (self.compression, "compression", OfPropertyString),
            (self.load,  "load",              OfPropertyH32),
            (self.entry, "entry",             OfPropertyH32),
        ])

        self.signature.add_hash(self)

        return super().finish()



if __name__ == '__main__':
    class D:
        def __init__(self):
            pass

        def expand(self, s):
            return s

    image = (OfTree()
             .add_node(FitImage()
                       .add_node(OfNode("images")
                                 .add_node(FitPart("kernel", FitSignature)
                                           .set_inputfile("vmlinuz.gz"))))
             .finish())

    print(image.emit(D()))
