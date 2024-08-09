#!/bin/bash

# 假设 conanfile 没有 layout 字段。

#set -e
#set -x

script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

# opts
build_type='Debug' # OR `Release`

rm -rf build

does_exist_conanfile=false
[ -f "conanfile.txt" -o -f "conanfile.py" ] && does_exist_conanfile=true

conan_output_folder="generators"

if [ $build_type = 'Debug' ]; then
  # Ref: [Build the project with Debug while dependencies with Release](https://github.com/conan-io/conan/issues/13478#issuecomment-1475389368)
  [ $does_exist_conanfile = true ] && conan install . --build=missing --output-folder=build/$conan_output_folder -s "build_type=Release" -s "&:build_type=Debug" 
elif [ $build_type = 'Release' ]; then
  [ $does_exist_conanfile = true ] && conan install . --build=missing --output-folder=build/$conan_output_folder
fi

[ ! -d build ] && mkdir build

cd build

# ## Generate build system
#compiler="env CC=/usr/bin/clang CXX=/usr/bin/clang++"
#compiler="env CC=/usr/bin/gcc CXX=/usr/bin/g++"
cmake_option=("-G Ninja")
cmake_option+=("-DCMAKE_EXPORT_COMPILE_COMMANDS=1")
if [ $build_type = 'Debug' ]; then
  cmake_option+=("-DCMAKE_BUILD_TYPE=Debug")
elif [ $build_type = 'Release' ]; then
  cmake_option+=("-DCMAKE_BUILD_TYPE=Release")
fi
if [ $does_exist_conanfile = true ]; then
  cmake_option+=("-DCMAKE_TOOLCHAIN_FILE=$conan_output_folder/conan_toolchain.cmake")
fi
$compiler cmake .. ${cmake_option[*]}

# ## Compile/Link
cmake --build .

cd ..
