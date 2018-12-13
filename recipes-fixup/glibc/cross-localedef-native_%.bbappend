SRCREV_localedef = "c328777219ccc480be3112cf807217ca6b570b64"

## TODO: why is this not done by bitbake?
do_unpack[vardeps] += "SRCREV_localedef"
