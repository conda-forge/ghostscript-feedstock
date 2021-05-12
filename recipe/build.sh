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

# Explicitly disable CUPS support:
#   - On Linux libcups (or CDT) dep is required if CUPS support should be added.
#   - On macOS the clang=10 build disables CUPS and clang=11 fails to link it.
#     Build log excerpt from build for commit https://github.com/conda-forge/ghostscript-feedstock/pull/21/commits/6f7a3b8d967916c49682f50e479fcd9bd84ff3fe :
#       ./obj/aux/echogs -w ./obj/ldt.tr -n - x86_64-apple-darwin13.4.0-clang -Wl,-pie -Wl,-headerpad_max_install_names -Wl,-dead_strip_dylibs -Wl,-rpath,$PREFIX/lib -L$PREFIX/lib   -o ./bin/gs
#       ./obj/aux/echogs -a ./obj/ldt.tr -n -s ./obj/gsromfs1.o ./obj/gs.o -s
#       cat ./obj/gsld.tr >> ./obj/ldt.tr
#       ./obj/aux/echogs -a ./obj/ldt.tr -s -  -lm -ldl  -liconv      -lpthread -lm 
#       if [ x != x ]; then LD_RUN_PATH=; export LD_RUN_PATH; fi; \
#       	XCFLAGS= XINCLUDE= XLDFLAGS= XLIBDIRS= XLIBS= \
#       	PSI_FEATURE_DEVS= FEATURE_DEVS= DEVICE_DEVS= DEVICE_DEVS1= DEVICE_DEVS2= DEVICE_DEVS3= \
#       	DEVICE_DEVS4= DEVICE_DEVS5= DEVICE_DEVS6= DEVICE_DEVS7= DEVICE_DEVS8= \
#       	DEVICE_DEVS9= DEVICE_DEVS10= DEVICE_DEVS11= DEVICE_DEVS12= \
#       	DEVICE_DEVS13= DEVICE_DEVS14= DEVICE_DEVS15= DEVICE_DEVS16= \
#       	DEVICE_DEVS17= DEVICE_DEVS18= DEVICE_DEVS19= DEVICE_DEVS20= \
#       	DEVICE_DEVS_EXTRA= \
#       	/bin/sh <./obj/ldt.tr
#       Undefined symbols for architecture x86_64:
#         "_cupsRasterClose", referenced from:
#             _cups_close in gdevcups.o
#         "_cupsRasterOpen", referenced from:
#             _cups_print_pages in gdevcups.o
#         "_cupsRasterWriteHeader2", referenced from:
#             _cups_print_pages in gdevcups.o
#         "_cupsRasterWritePixels", referenced from:
#             _cups_print_pages in gdevcups.o
#             _cups_print_chunked in gdevcups.o
#       ld: symbol(s) not found for architecture x86_64
#       clang-11: error: linker command failed with exit code 1 (use -v to see invocation)
#       make: *** [bin/gs] Error 1

./configure \
    --prefix=${PREFIX} \
    --disable-cups \
    --without-tesseract

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check -j${CPU_COUNT}
fi
make install -j${CPU_COUNT}

mkdir -p ${PREFIX}/lib

cp ./sobin/libgs.* ${PREFIX}/lib/
