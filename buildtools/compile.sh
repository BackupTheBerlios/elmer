#!/bin/bash
#
# Always compile into tmp
#
EPREFIX=/tmp/vierinen/elmer

if test "$1" = "clean"; then
    rm -Rf $EPREFIX
fi

modules="matc mathlibs eio hutiter fem"

tmpname=`hostname``date '+%Y%M%S'`
TESTPREFIX=$EPREFIX/$tmpname
rm -Rf $TESTPREFIX

export CVSROOT="vierinen@corona.csc.fi:/home/csc/vierinen/cvsroot"
export CVS_RSH="ssh"

rm -Rf $modules
cvs co $modules

for m in $modules; do
    cd $m
    ./configure --prefix=$TESTPREFIX $CONFFLAGS
    gmake -j42
    make install
    if test "$m" = fem; then
	make check
    fi
    cd ..
done
