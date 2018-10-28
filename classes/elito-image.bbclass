IMAGE_FEATURES[validitems] += "devel-history devel-sshkey no-root-bash"

USER_CONFIG_DIR = "~${USER}/.config/oe"

elito_add_devel_history() {
	d=`hostname -d 2>/dev/null` && d=-$d
	h=`hostname -f 2>/dev/null || hostname` && h=-$h

	for p in "$h" "$d" ""; do
		f='${PROJECT_TOPDIR}'/files/bash_history$p
		test -e "$f" || continue
		install -D -p -m 0600 "$f" '${IMAGE_ROOTFS}${ROOT_HOME}'/.bash_history
		break
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
		f="${PROJECT_TOPDIR}"/files/authorized_keys$p
		! test -e "$f" || break
	done
}

elito_add_devel_sshkey() {
	f=`env PSEUDO_UNLOAD=1 bash -c 'echo ${USER_CONFIG_DIR}/authorized_keys'`
	if ! test -e "$f"; then
		_elito_search_devel_sshkey
	fi

	! test -e "$f" || \
		install -D -p -m 0644 "$f" ${IMAGE_ROOTFS}${ROOT_HOME}/.ssh/authorized_keys
}

elito_set_rootbash() {
	f=${IMAGE_ROOTFS}/etc/passwd
	b=${IMAGE_ROOTFS}/bin/bash
	test -w "$f" || return 0

	if test -x "$b" || test -L "$b"; then
		sed -i -e 's!^\(root:.*:\)/bin/sh$!\1/bin/bash!' "$f"
	fi
}

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
