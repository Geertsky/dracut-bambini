#!/bin/bash
if [ -z "$PKG_CONFIG_PATH" ]; then
  export PKG_CONFIG_PATH="$CONDA_PREFIX"/lib/pkgconfig
elif [[ ! $PKG_CONFIG_PATH =~ "$CONDA_PREFIX/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$CONDA_PREFIX"/lib/pkgconfig
fi
mkdir build
cd build
export CFLAGS="${CFLAGS} -std=gnu17"
../configure --prefix=$PREFIX         \
             --enable-elf-shlibs      \
             --disable-libblkid       \
             --disable-uuidd          \
	     --disable-libuuid	      \
             --disable-fsck           \
             --exec-prefix=$PREFIX    \
	     --with-crond-dir=$PREFIX/etc/cron.d/ \
             --with-udev-rules-dir=$PREFIX/lib/udev-rules.d/ \
             --with-systemd-unit-dir=$PREFIX/lib/systemd/system/
make
make install
# Avoid clobbering util-linux / libuuid / krb5 packages.
rm -f "$PREFIX/bin/compile_et"
rm -f "$PREFIX/include/com_err.h"
rm -f "$PREFIX/lib/libcom_err."*
rm -rf "$PREFIX/share/et"
rm -f "$PREFIX/share/man/man1/compile_et.1"
# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
