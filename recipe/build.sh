#!/bin/bash

./configure --prefix=${PREFIX}

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install -j${CPU_COUNT}

if [ ! -d ${PREFIX}/lib ]; then
    mkdir -p ${PREFIX}/lib
fi

cp ./sobin/libgs.* ${PREFIX}/lib/
