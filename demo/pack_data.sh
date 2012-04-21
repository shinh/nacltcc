#!/bin/sh
#
# Pack data for NaCl tcc web interface
#
#  Copyright (c) 2011 Shinichiro Hamaji
#
# Usage:
#
# % ./pack_data.sh <path-to-your-simple_tar.py>
#


if [ ! -x $1 ]; then
    echo "Usage: $0 <path-to-your-simple_tar.py>"
fi

export FETCH_ENVS_ONLY=1
. ../nacl-configure

set -x

rm -fr usr data.sar

mkdir -p usr
cp -r $NACL_INCLUDE_DIR usr
rm -fr usr/include/c++

mkdir -p usr/lib/tcc
cp -r ../include usr/lib/tcc

tar -cvf data.tar usr

echo DONE!
