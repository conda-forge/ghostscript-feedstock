#!/bin/bash

./configure --prefix=${PREFIX}

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install -j${CPU_COUNT}

if [ ! -d ${PREFIX}/lib ]; then
    mkdir -p ${PREFIX}/lib
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    cp ./sobin/libgs.*dylib ${PREFIX}/lib/
else
    cp ./sobin/libgs.so* ${PREFIX}/lib/
fi

