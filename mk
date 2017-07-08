#!/bin/bash
set -x
# set this to the location of your node-gyp dir:
MY_GYP_DIR=/home/ljw/.node-gyp/4.8.3
# nuke the install dir
rm -r install
mkdir install
mkdir install/bin
mkdir install/lib

# first build napi-compatibility-module.so and move it in to place in the install/lib dir
g++  '-DUSING_UV_SHARED=1' '-DUSING_V8_SHARED=1' '-DV8_DEPRECATION_WARNINGS=1' '-D_LARGEFILE_SOURCE' '-D_FILE_OFFSET_BITS=64' '-DBUILDING_NODE_EXTENSION' -I$MY_GYP_DIR/include/node -I$MY_GYP_DIR/src -I$MY_GYP_DIR/deps/uv/include -I$MY_GYP_DIR/deps/v8/include  -fPIC -pthread -Wall -Wextra -Wno-unused-parameter -m64 -O0 -fno-omit-frame-pointer -fno-rtti -fno-exceptions -std=gnu++0x -Wl,--version-script=./version.script -c node_api.cc 
g++ -Wl,--version-script=./version.script node_api.o -shared -o napi-compatibility-module.so
rm node_api.o
mv napi-compatibility-module.so install/lib

# next build napi-compatibility-module-loader.node . This is used to load
# napi-compatibility-module.so using dlopen and the flags RTLD_NOW and RTLD_GLOBAL
# moves the module in to place in install/lib

# nuke the build dir
rm -r build
# build with node-gyp
node-gyp configure
node-gyp build
# move across to install/lib
mv build/Release/napi-compatibility-module-loader.node install/lib
cp node-napi install/bin
cp napi-compatibility-module-loader-loader.js install/lib
set +x
