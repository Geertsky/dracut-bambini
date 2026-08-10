#!/bin/bash
./configure --prefix=$PREFIX            \
            --enable-compat-symlinks \
            --datadir=$PREFIX \
            --sbindir=$PREFIX/bin

make
make install
