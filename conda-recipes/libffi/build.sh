#!/bin/bash
./autogen.sh
./configure --prefix=$PREFIX       \
            --disable-static       \
            --with-gcc-arch=native \
            --disable-exec-static-tramp
make&&make check&&make install
