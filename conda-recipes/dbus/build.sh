#/bin/bash
./configure --prefix=$PREFIX                        \
            --sysconfdir=$PREFIX/etc                    \
            --localstatedir=$PREFIX/var                 \
            --runstatedir=$PREFIX/run                   \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --disable-static                     \
            --with-systemduserunitdir=no         \
            --with-systemdsystemunitdir=no       \
            --docdir=$PREFIX/doc/dbus-1.14.10  \
            --with-system-socket=/$PREFIX/run/dbus/system_bus_socket &&
make
make install
