if [ -z ${CONDA_BUILD+x} ]; then
    source /home/geert/miniforge3/conda-bld/libbytesize_1711284366822/work/build_env_setup.sh
fi
#!/bin/bash

export CFLAGS=$CFLAGS" -I$BUILD_PREFIX/include" # -L$BUILD_PREFIX/lib"
./configure \
  --prefix=$PREFIX \
  --with-python-sys-prefix
make
make install
