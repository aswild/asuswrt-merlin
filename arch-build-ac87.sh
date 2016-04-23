#! /bin/bash

BASEDIR=$(readlink -f $(dirname $0))

RELEASEDIR="$BASEDIR/release/src-rt-6.x.4708"
export TOOLCHAIN="$RELEASEDIR/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3"
export autom4te_perllibdir=$TOOLCHAIN/share/autoconf
export perllibdir=$TOOLCHAIN/share/automake-1.11:$TOOLCHAIN/share/aclocal-1.11

export PATH=$TOOLCHAIN/bin:$PATH
export LD_LIBRARY_PATH=$TOOLCHAIN/lib:/usr/lib32:/usr/lib
export LD_LIBRARY_PRELOAD=$TOOLCHAIN/lib:/usr/lib32:/usr/lib

start_time=$(date +%s)
if [[ -z $1 ]]; then
    make -C $RELEASEDIR RT-AC87U
    make_ret=$?
else
    make -C $RELEASEDIR "$@"
    make_ret=$?
fi
end_time=$(date +%s)
total_time=$(($end_time - $start_time))
elapsed_time="(total time: $(($total_time / 60))m $(($total_time % 60))s)"

# colors
reset=`tput sgr0`
red="$(tput setaf 1)$(tput bold)"
green="$(tput setaf 2)$(tput bold)"

if [[ $make_ret == 0 ]]; then
    echo -e "\n  ${green}make SUCCESS ${elapsed_time} ${reset}"
else
    echo -e "\n  ${red}make FAILED with exit code ${make_ret}. ${elapsed_time} ${reset}"
fi

# Besides setting the environment variables above, install these packages with pacman:
#   ib32-glibc gcc-libs-multilib lib32-elfutils bc id3lib gperf intltool
#
# The autotools perl scripts look for some hard-coded paths for share files
# Symlink or copy $TOOLCHAIN/share to /opt/brcm-arm/share
# Also, copy/symlink the entire toolchain to
#   /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3
