#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./jpeg
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lcms2mt
cp $BUILD_PREFIX/share/gnuconfig/config.* ./ijs
cp $BUILD_PREFIX/share/gnuconfig/config.* .
cp $BUILD_PREFIX/share/gnuconfig/config.* ./tiff/config

./configure --prefix=${PREFIX}

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check -j${CPU_COUNT}
fi
make install -j${CPU_COUNT}

if [ ! -d ${PREFIX}/lib ]; then
    mkdir -p ${PREFIX}/lib
fi

cp ./sobin/libgs.* ${PREFIX}/lib/
