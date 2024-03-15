#!/bin/bash
set -x
#export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include"
export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig/
export CPPFLAGS="$CPPFLAGS"' -I '$BUILD_PREFIX'/include'
echo mkdir -p $PREFIX
mkdir -p $PREFIX
ls -ld $PREFIX
./autogen.sh
./configure \
  --disable-rpath \ 
--prefix=$PREFIX
make
make install
