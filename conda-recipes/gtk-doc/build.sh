#!/bin/bash
mkdir -p build &&
cd       build &&

meson setup --prefix=$PREFIX --libdir=$PREFIX/lib --buildtype=release .. &&
ninja
ninja install
