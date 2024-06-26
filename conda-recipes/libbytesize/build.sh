#!/bin/bash

export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include" # -L$BUILD_PREFIX/lib"
./configure \
  --prefix=$PREFIX \
  --with-python-sys-prefix \
  --with-gtk-doc=no
make
make install
