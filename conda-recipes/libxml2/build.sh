#!/bin/bash
./configure --prefix=$PREFIX           \
            --sysconfdir=$PREFIX/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=$BUILD_PREFIX/bin/python3 \
            --docdir=$PREFIX/doc/libxml2-2.12.6 &&
make
make install
rm -vf $PREFIX/lib/libxml2.la &&
sed '/libs=/s/xml2.*/xml2"/' -i $PREFIX/bin/xml2-config
