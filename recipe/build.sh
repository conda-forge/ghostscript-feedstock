#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./tiff/config
cp $BUILD_PREFIX/share/gnuconfig/config.* .
cp $BUILD_PREFIX/share/gnuconfig/config.* ./jpeg
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lcms2mt
cp $BUILD_PREFIX/share/gnuconfig/config.* ./ijs

# Build without Tesseract OCR support:
#   - Sources for 9.53 did not include everything for default Tesseract support.
#     => conda-forge::ghostscript<9.54 does not have Tesseract support.
#   - Upstream does not support linking to external Tesseract library.
#     - macOS builds fail because ./configure sets -stdlib=stdlibc++.
#     - We try to avoid vendoring at conda-forge.
#       => Better to wait for upstream to support linking to external library.
./configure \
    --prefix=${PREFIX} \
    --without-tesseract

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check -j${CPU_COUNT}
fi
make install -j${CPU_COUNT}

mkdir -p ${PREFIX}/lib

cp ./sobin/libgs.* ${PREFIX}/lib/
