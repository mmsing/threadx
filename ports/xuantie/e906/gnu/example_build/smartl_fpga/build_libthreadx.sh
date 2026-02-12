#!/bin/bash

pushd ../../../../../../
rm -rf build
cmake -Bbuild -GNinja -DCMAKE_TOOLCHAIN_FILE=ports/xuantie/e906/gnu/example_build/smartl_fpga/xuantie_e906_gnu.cmake .
cmake --build ./build/
popd
