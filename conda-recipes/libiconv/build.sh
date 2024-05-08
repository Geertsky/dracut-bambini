if [ -z ${CONDA_BUILD+x} ]; then
    source /home/geert/miniforge3/conda-bld/libiconv_1711011190394/work/build_env_setup.sh
fi
#!/bin/bash
#export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include"
export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig/
export CPPFLAGS="$CPPFLAGS"' -I '$BUILD_PREFIX'/include'
#echo mkdir -p $PREFIX
#mkdir -p $PREFIX
#ls -ld $PREFIX
./configure --prefix="$PREFIX"
make
make install
