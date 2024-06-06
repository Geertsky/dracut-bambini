#!/bin/bash
autoreconf -f -i
autoupdate
./configure --prefix=$PREFIX --sysconfdir=$PREFIX/etc
make

make docdir=$PREFIX/doc install &&

install-catalog --add $PREFIX/etc/sgml/sgml-ent.cat \
    $PREFIX/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --add $PREFIX/etc/sgml/sgml-docbook.cat \
    $PREFIX/etc/sgml/sgml-ent.cat
