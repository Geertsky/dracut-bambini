#!/bin/sh
#./bootstrap.sh
echo |cpan Thread::Queue
./configure --prefix=$PREFIX
make
make install
