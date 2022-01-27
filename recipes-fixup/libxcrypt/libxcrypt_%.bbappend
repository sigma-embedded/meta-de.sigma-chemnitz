### sdk build fails else in do_configure with
###
### | checking for Python 3.>=6 with Passlib... not found
### | configure: Disabling the "regen-ka-table" target, missing Python requirements.
### | Can't locate open.pm in @INC (you may need to install the open module) (@INC contains: /usr/local/lib64/perl5/5.34 /usr/local/share/perl5/5.34 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5) at ../git/build-aux/scripts/expand-selected-hashes line 20.
### | BEGIN failed--compilation aborted at ../git/build-aux/scripts/expand-selected-hashes line 20.

inherit perlnative
