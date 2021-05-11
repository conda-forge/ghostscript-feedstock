#!/bin/bash

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
make check -j${CPU_COUNT}
make install -j${CPU_COUNT}

if [ ! -d ${PREFIX}/lib ]; then
    mkdir -p ${PREFIX}/lib
fi

cp ./sobin/libgs.* ${PREFIX}/lib/
