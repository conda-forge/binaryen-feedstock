#!/bin/bash

export CMAKE_CONFIG="Release"

EXTRA_CMAKE_ARGS=""
if [[ `uname` == 'Darwin' ]];
then
    EXTRA_CMAKE_ARGS="-DCMAKE_MACOSX_RPATH:BOOL=ON"
fi
export EXTRA_CMAKE_ARGS

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

# this fixes an issue where "some toolchains it is necessary to #define __STDC_FORMAT_MACROS before using macros like PRIxPTR"
# cf: https://github.com/tensorflow/tensorflow/issues/12998#issuecomment-329179887
if [[ `uname` == 'Linux' ]];
then
    export CXXFLAGS="${CXXFLAGS} -D__STDC_FORMAT_MACROS"
    export CFLAGS="${CFLAGS} -D__STDC_FORMAT_MACROS"
fi

mkdir "build_${CMAKE_CONFIG}"
pushd "build_${CMAKE_CONFIG}"

cmake ${CMAKE_ARGS} -G "Ninja" \
    -DCMAKE_BUILD_TYPE:STRING="${CMAKE_CONFIG}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_TESTS=OFF \
    -DENABLE_WERROR=0 \
    ${EXTRA_CMAKE_ARGS} \
    "${SRC_DIR}"

ninja
ninja install
popd

# Needs Emscripten and other stuff to work.
#pushd "${SRC_DIR}"
#$PYTHON ./check.py
#popd
