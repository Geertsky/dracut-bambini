#!/bin/bash

#export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include"
#export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig/
export CPPFLAGS="$CPPFLAGS"' -I '$BUILD_PREFIX'/include'
#ln -s $BUILD_PREFIX/bin/aclocal{,-1.13}
#ln -s $BUILD_PREFIX/bin/automake{,-1.13}
#ln -s $BUILD_PREFIX/lib/libnsl.so{,.1}
#mkdir gnulib
#wget -O gnulib/gnulib-tool https://raw.githubusercontent.com/coreutils/gnulib/master/gnulib-tool
#chmod +x gnulib/gnulib-tool
#patch libparted/arch/linux.c <$RECIPE_DIR/001-linux-blkid.patch
#./bootstrap
./configure \
  --prefix=$PREFIX
make
make install
