#! /bin/bash

BASEDIR=$(readlink -f $(dirname $0))

RELEASEDIR="$BASEDIR/release/src-rt-6.x.4708"
export TOOLCHAIN="$RELEASEDIR/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3"
export autom4te_perllibdir=$TOOLCHAIN/share/autoconf
export perllibdir=$TOOLCHAIN/share/automake-1.11:$TOOLCHAIN/share/aclocal-1.11

export PATH=$TOOLCHAIN/bin:$PATH
export LD_LIBRARY_PATH=$TOOLCHAIN/lib:/usr/lib32:/usr/lib
export LD_LIBRARY_PRELOAD=$TOOLCHAIN/lib:/usr/lib32:/usr/lib

make -C $RELEASEDIR RT-AC87U

# Besides setting the environment variables above, install these packages with pacman:
#   ib32-glibc gcc-libs-multilib lib32-elfutils bc id3lib gperf intltool
#
# The autotools perl scripts look for some hard-coded paths for share files
# Symlink or copy $TOOLCHAIN/share to /opt/brcm-arm/share
# Also, copy/symlink the entire toolchain to
#   /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3
