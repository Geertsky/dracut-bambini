#!/bin/bash
make DEBUG=-DNDEBUG PREFIX=$PREFIX
make PKG_DOC_DIR=$PREFIX/doc/xfsprogs-6.6.0 install     &&
make PKG_DOC_DIR=$PREFIX/doc/xfsprogs-6.6.0 install-dev &&
