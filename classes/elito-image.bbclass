IMAGE_FEATURES[validitems] += "devel-history devel-sshkey no-root-bash"

USER_CONFIG_DIRS ?= "~${USER}/.config/openembedded ~${USER}/.config/oe ~${USER}/.config/elito"
USER_CONFIG_DIRS[doc] = "list of space separated paths where user configuration will be searched"
USER_CONFIG_DIRS[type] = "list"

USER_CONFIG_DIRS_EXPANDED = "${@' '.join(map(lambda x: host_expanduser(x), oe.data.typed_value('USER_CONFIG_DIRS', d)))}"
USER_CONFIG_DIRS_EXPANDED[type] = "list"

USER_CONFIG_DIR ?= "${@find_first_directory(oe.data.typed_value('USER_CONFIG_DIRS_EXPANDED', d))}"

ELITO_IMAGE_CFG_PATH ??= "${PROJECT_TOPDIR}/files"
ELITO_IMAGE_CFG_PATH[type] = "list"

_ELITO_IMAGE_CFG_PATH = "${@oe.data.typed_value('ELITO_IMAGE_CFG_PATH', d)}"

do_image_complete[recrdeptask] += "do_emit_buildvars_rec"

def host_expanduser(dir):
    ## we have to expand it in an extra subprocess with clean environment
    ## because function might be run within PSEUDO context
    cmd = [sys.executable, '-c', 'import sys, os.path; sys.stdout.write(os.path.expanduser(sys.argv[1]))', dir]
    env = { 'PSEUDO_DISABLED' : '1' }

    res = bb.process.Popen(cmd, shell = False, env = env).communicate()[0]
    return res.decode('ascii')

def find_first_directory(dirs):
    for d in dirs:
        if os.path.isdir(d):
            return d

    return ""

elito_add_devel_history() {
	d=`hostname -d 2>/dev/null` && d=-$d
	h=`hostname -f 2>/dev/null || hostname` && h=-$h

	for p in "$h" "$d" ""; do
	    for dir in ${_ELITO_IMAGE_CFG_PATH}; do
		f=$dir/bash_history$p
		test -e "$f" || continue
		install -D -p -m 0600 "$f" '${IMAGE_ROOTFS}${ROOT_HOME}'/.bash_history
		break 2
	    done
	done
}

_elito_search_devel_sshkey() {
	u='${USER}' || u=
	d=`hostname -d 2>/dev/null` || d=
	h=`hostname -f 2>/dev/null || hostname` || h=

	set --

	if test -n "$u"; then
		set -- "$@" ${h:+"-$u@$h"} ${d:+"-$u@$d"} "-${u}@"
	fi

	set -- "$@" ${h:+"-$h"} ${d:+"-$d"} ""

	for p in "$@"; do
	    for dir in ${_ELITO_IMAGE_CFG_PATH}; do
		f=$dir/authorized_keys$p
		! test -e "$f" || break 2
	    done
	done
}

elito_add_devel_sshkey() {
	f='${USER_CONFIG_DIR}/authorized_keys'
	if ! test -e "$f"; then
		_elito_search_devel_sshkey
	fi

	test -e "$f" || return

	d='${IMAGE_ROOTFS}${ROOT_HOME}/.ssh/authorized_keys'
	if test -e "$d"; then
	    cat "$f" >> "$d"
	else
	    install -D -p -m 0644 "$f" "$d"
	fi
}

elito_set_rootbash() {
	f=${IMAGE_ROOTFS}${sysconfdir}/passwd
	b=${IMAGE_ROOTFS}${base_bindir}/bash
	test -w "$f" || return 0

	if test -x "$b" || test -L "$b"; then
		sed -i -e 's!^\(root:.*:\)/bin/sh$!\1${base_bindir}/bash!' "$f"
	fi
}

elito_reenable_sysrq() {
	echo 'kernel.sysrq = 1' > '${IMAGE_ROOTFS}'/etc/sysctl.d/99-sysctl.conf
}

ROOTFS_POSTPROCESS_COMMAND += "${@\
  bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', \
		    'elito_reenable_sysrq ;', '', d)}"

ROOTFS_POSTPROCESS_COMMAND += "${@\
  bb.utils.contains('IMAGE_FEATURES', 'devel-history', \
		    'elito_add_devel_history ;', '', d)}"

ROOTFS_POSTPROCESS_COMMAND += "${@\
  bb.utils.contains('IMAGE_FEATURES', 'devel-sshkey', \
		    'elito_add_devel_sshkey ;', '', d)}"

ROOTFS_POSTPROCESS_COMMAND += "${@\
  bb.utils.contains('IMAGE_FEATURES', 'no-root-bash', \
		    '', 'elito_set_rootbash ;', d)}"

ROOTFS_POSTPROCESS_COMMAND_remove = "${@\
  bb.utils.contains('IMAGE_FEATURES', 'devel-sshkey', \
  bb.utils.contains('IMAGE_FEATURES', 'allow-empty-password', \
                    '', 'ssh_allow_empty_password;', d), '', d)}"
