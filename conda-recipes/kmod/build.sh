#!/bin/bash
./autogen.sh c
./configure --prefix=$PREFIX          \
            --sysconfdir=$PREFIX/etc      \
            --libdir=$PREFIX/lib    \
            --disable-manpages    \
            --with-bashcompletiondir=$PREFIX/etc/bash_completion.d/ \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make
make install
cd $PREFIX
mkdir sbin
for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv bin/kmod sbin/$target
done

ln -sfv bin/kmod bin/lsmod
