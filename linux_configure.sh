#!/bin/sh

rm -rf build
mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX:PATH=$HOME/software/mk4-pipeline \
  -DIDL_ROOT_DIR:PATH=/opt/share/idl8.5/idl85 \
  -DGSL_ROOT_DIR:PATH=$HOME/software \
  ..
