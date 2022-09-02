set CMAKE_CONFIG=Release

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%
cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE:STRING="%CMAKE_CONFIG%" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_TESTS=OFF ^
    -DENABLE_WERROR=0 ^
    "%SRC_DIR%"
ninja
ninja install
popd

:: Needs Emscripten and other stuff to work.
::pushd "%SRC_DIR%"
::%PYTHON% .\check.py
::popd
