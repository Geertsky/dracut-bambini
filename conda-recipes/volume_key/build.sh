#!/bin/bash
ln -s $(which gpg){,2}
if [[ ! $CFLAGS =~ "--sysroot=" ]]; then
  export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT $CFLAGS"
fi
if [[ ! CFLAGS =~ "include/python" ]]; then
  export CFLAGS="$(python3-config --includes) $CFLAGS"
fi
if [[ ! $PKG_CONFIG_PATH =~ "$CONDA_PREFIX/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$CONDA_PREFIX"/lib/pkgconfig
fi
autoreconf -fiv              &&
./configure --prefix=$PREFIX    \
make&&make install
