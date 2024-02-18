## ensure that main build targets do not run with broken sstate
all image sdk:	sstate-check

ci-info:
	${MAKE} -s bitbake BITBAKE=bitbake-layers T= BO=show-layers
	${MAKE} -s bitbake BITBAKE=bitbake-layers T= BO=show-overlayed
