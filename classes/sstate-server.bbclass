## SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only
##
## OE part of the sstate-server server
##
## https://gitlab-ext.sigma-chemnitz.de/ensc/sstate-server
##


## SSTATE_MIRRORS
SSTATE_MIRRORS_prepend = "${@sstate_server_get_mirrors(d, 'SSTATE_SERVER_SSTATE_MIRRORS')}"

SSTATE_SERVER_SSTATE_MIRRORS[vardepsexclude] += "PN SSTATE_SERVER_API SSTATE_SERVER_PATH"
SSTATE_SERVER_SSTATE_MIRRORS[doc] = "SSTATE_MIRRORS used when sstate-server is activated"
SSTATE_SERVER_SSTATE_MIRRORS = "\
    file://.*    ${SSTATE_SERVER_API}/v1/download/${SSTATE_SERVER_PATH}/sstate/${PN}/PATH \
"

## PREMIRRORS
PREMIRRORS_prepend = "${@sstate_server_get_mirrors(d, 'SSTATE_SERVER_PREMIRRORS')}"

SSTATE_SERVER_PREMIRRORS[vardepsexclude] += "PN SSTATE_SERVER_API SSTATE_SERVER_PATH"
SSTATE_SERVER_PREMIRRORS[doc] = "PREMIRRORS used when sstate-server is activated"
## TODO: ${PN} is not expanded... why?
SSTATE_SERVER_PREMIRRORS = " \
    ftp://.*/.*    ${SSTATE_SERVER_API}/v1/download/${SSTATE_SERVER_PATH}/source/${PN}/ \n\
    https?://.*/.* ${SSTATE_SERVER_API}/v1/download/${SSTATE_SERVER_PATH}/source/${PN}/ \n\
    git://.*/.*    ${SSTATE_SERVER_API}/v1/download/${SSTATE_SERVER_PATH}/scm/${PN}/${@sstate_server_srcrev(d)} \n\
"

## SSTATE API
SSTATE_SERVER_API ??= ""
SSTATE_SERVER_PATH ??= "-"
SSTATE_SERVER_SESSION ??= "-"

SSTATE_SERVER_DISABLED ??= "false"
SSTATE_SERVER_DISABLED[type] = "boolean"

BB_HASHBASE_WHITELIST += "\
    SSTATE_SERVER_PATH SSTATE_SERVER_SESSION SSTATE_SERVER_API _SSTATE_SERVER_INFO \
    sstate_server_post_create \
"

def sstate_server_get_mirrors(d, var):
    if (d.getVar('SSTATE_SERVER_API', True) or '').strip() == "":
        return ""
    else:
        return '${' + var + '}'

def sstate_server_dl_get(d):
    import sstate_server
    return sstate_server.get_session(d, 1) or "-"

def sstate_server_srcrev(d):
    ## TODO: this is not working; SRCREV is not populated by bb.fetch2
    ## when expanding the mirror list
    srcrev = d.getVar("SRCREV", False)
    if srcrev != "AUTOINC":
        srcrev = d.expand(srcrev)

    return srcrev

python sstate_server_eventhandler () {
    import sstate_server

    sstate_server.handle_event(e)
}
addhandler sstate_server_eventhandler

## TODO: see below
# python sstate_server_post_create () {
#     import sstate_server
#
#     sstate_server.post_create(d)
# }

## TODO: does not work; 'sstate' might be inherited after 'sstate-server'
# python () {
#     unique_tasks = sorted(set((d.getVar('SSTATETASKS') or "").split()))
#     for task in unique_tasks:
#         d.appendVarFlag(task, 'vardepsexclude', '| sstate_server_post_create')
#         d.appendVarFlag(task, 'postfuncs', " sstate_server_post_create")
# }

## TODO: when running 'SSTATEPOSTCREATEFUNCS', the .siginfo' files are
##       not created yet
# SSTATEPOSTCREATEFUNCS[vardepvalueexclude] .= "| sstate_server_post_create"
# SSTATEPOSTCREATEFUNCS_append = " sstate_server_post_create"

## TODO: does not work; 'postfuncs' of 'postfuncs' are not supported
# python () {
#       v = 'sstate_task_postfunc'
#       d.appendVarFlag(v, 'vardepsexclude', '| sstate_server_post_create')
#       d.appendVarFlag(v, 'postfuncs', " sstate_server_post_create")
# }

## TODO: see above
#sstate_task_postfunc[vardepvalueexclude] .= "| sstate_server_post_create"
#sstate_task_postfunc[postfuncs]
