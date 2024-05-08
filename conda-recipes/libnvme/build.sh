#!/bin/bash
mkdir build &&
cd    build &&

meson setup --prefix=$PREFIX --buildtype=release -Dlibdbus=disabled -Dlibdir=lib .. &&
ninja&&ninja install
