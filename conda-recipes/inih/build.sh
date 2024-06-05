#!/usr/bin/env bash

# get meson to find pkg-config when cross compiling
#export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

mkdir build &&
cd    build &&

meson setup --prefix=$PREFIX --libdir lib --buildtype=release .. &&
ninja
ninja install
