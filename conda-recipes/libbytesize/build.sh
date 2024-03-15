#!/bin/bash

export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include" # -L$BUILD_PREFIX/lib"
#export PYTHON=$(which python)
./autogen.sh
./configure \
  --prefix=$PREFIX \
  --with-python-sys-prefix
make
make install
