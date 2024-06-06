#!/bin/bash
make prefix=$PREFIX
if [ -z "$(make check|grep FAIL)" ]; then
  make prefix=$PREFIX install
  rm -v $PREFIX/lib/libzstd.a
else
  exit -1
fi
