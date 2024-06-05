#!/bin/bash
#Installation of DocBook-4.5 XML DTD
install -v -d -m755 $PREFIX/xml-dtd-4.5
install -v -d -m755 $PREFIX/etc/xml
cp -v -af --no-preserve=ownership docbook.cat *.dtd ent/ *.mod \
    $PREFIX/xml-dtd-4.5

#Create (or update) and populate the /etc/xml/docbook catalog
if [ ! -e $PREFIX/etc/xml/docbook ]; then
    xmlcatalog --noout --create $PREFIX/etc/xml/docbook
fi &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/calstblx.dtd" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file://$PREFIX/xml-dtd-4.5/soextblx.dtd" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/dbpoolx.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/dbhierx.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/htmltblx.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/dbnotnx.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file://$PREFIX/xml-dtd-4.5/dbcentx.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file://$PREFIX/usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file://$PREFIX/xml-dtd-4.5" \
    $PREFIX/etc/xml/docbook &&
xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file://$PREFIX/xml-dtd-4.5" \
    $PREFIX/etc/xml/docbook
if [ ! -e $PREFIX/etc/xml/catalog ]; then
    xmlcatalog --noout --create $PREFIX/etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog

# Configuration Information 
for DTDVERSION in 4.1.2 4.2 4.3 4.4
do
  xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
    $PREFIX/etc/xml/docbook
  xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file://$PREFIX/xml-dtd-4.5" \
    $PREFIX/etc/xml/docbook
  xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file://$PREFIX/xml-dtd-4.5" \
    $PREFIX/etc/xml/docbook
  xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog
  xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file://$PREFIX/etc/xml/docbook" \
    $PREFIX/etc/xml/catalog
done
