#!/bin/bash
install -v -m755 -d $PREFIX/docbook/xsl-stylesheets-nons-1.79.2 &&

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    $PREFIX/docbook/xsl-stylesheets-nons-1.79.2 &&

ln -s VERSION $PREFIX/xsl-stylesheets-nons-1.79.2/VERSION.xsl &&

install -v -m644 -D README \
                    $PREFIX/doc/docbook-xsl-nons-1.79.2/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    $PREFIX/doc/docbook-xsl-nons-1.79.2

if [ ! -d $PREFIX/etc/xml ]; then install -v -m755 -d $PREFIX/etc/xml; fi &&
if [ ! -f $PREFIX/etc/xml/catalog ]; then
    xmlcatalog --noout --create $PREFIX/etc/xml/catalog
fi &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://cdn.docbook.org/release/xsl-nons/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://cdn.docbook.org/release/xsl-nons/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "$PREFIX/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    $PREFIX/etc/xml/catalog
