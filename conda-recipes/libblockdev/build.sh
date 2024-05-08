#!/bin/bash
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig/
export C_INCLUDE_PATH="$C_INCLUDE_PATH:$PREFIX/include:$PREFIX/include/nss:$PREFIX/include/nspr:$PREFIX/include/volume_key:$PREFIX/x86_64-conda-linux-gnu/sysroot/usr/include/"
[ ! -f $(which gpg2) ]&&ln -s $(which gpg){,2}
./configure --prefix=$PREFIX      \
            --sysconfdir=$PREFIX/etc  \
            --with-python3     \
            --without-gtk-doc  \
            --without-lvm_dbus \
            --without-nvdimm   \
            --without-tools    \
            --with-sysroot=$PREFIX/x86_64-conda-linux-gnu/sysroot/
make
make install
