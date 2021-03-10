#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export CC=clang
  export CXX=clang++
  export LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -headerpad_max_install_names $LDFLAGS"
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
fi

./configure --prefix=${PREFIX}

make -j${CPU_COUNT}
make so -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install -j${CPU_COUNT}

if [ ! -d ${PREFIX}/lib ]; then
    mkdir -p ${PREFIX}/lib
fi

cp ./sobin/libgs.* ${PREFIX}/lib/
