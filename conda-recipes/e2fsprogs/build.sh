#!/bin/bash
if [ -z "$PKG_CONFIG_PATH" ]; then
  export PKG_CONFIG_PATH="$CONDA_PREFIX"/lib/pkgconfig
elif [[ ! $PKG_CONFIG_PATH =~ "$CONDA_PREFIX/lib/pkgconfig" ]]; then
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$CONDA_PREFIX"/lib/pkgconfig
fi
mkdir build
cd build
../configure --prefix=$PREFIX         \
             --enable-elf-shlibs      \
             --enable-libblkid       \
             --enable-libuuid        \
             --disable-uuidd          \
             --disable-fsck           \
             --exec-prefix=$PREFIX    \
             --with-udev-rules-dir=$PREFIX/lib/udev-rules.d/ \
             --with-systemd-unit-dir=$PREFIX/lib/systemd/system/
make
make install
# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
