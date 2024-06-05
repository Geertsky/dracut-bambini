#!/bin/bash
sed -i 's/re.sub(/re.sub(r/'         itstool.in &&
sed -i 's/re.compile(/re.compile(r/' itstool.in
PYTHON=$(which python3) ./configure --prefix=$PREFIX &&
make
make install
