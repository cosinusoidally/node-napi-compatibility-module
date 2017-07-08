# set this to the location of your node-gyp dir:
MY_GYP_DIR=/home/ljw/.node-gyp/4.8.3
g++  '-DUSING_UV_SHARED=1' '-DUSING_V8_SHARED=1' '-DV8_DEPRECATION_WARNINGS=1' '-D_LARGEFILE_SOURCE' '-D_FILE_OFFSET_BITS=64' '-DBUILDING_NODE_EXTENSION' -I$MY_GYP_DIR/include/node -I$MY_GYP_DIR/src -I$MY_GYP_DIR/deps/uv/include -I$MY_GYP_DIR/deps/v8/include  -fPIC -pthread -Wall -Wextra -Wno-unused-parameter -m64 -O0 -fno-omit-frame-pointer -fno-rtti -fno-exceptions -std=gnu++0x -Wl,--version-script=./version.script -c node_api.cc 
g++ -Wl,--version-script=./version.script node_api.o -shared -o napi-compatibility-module.so
rm node_api.o
mv napi-compatibility-module.so install/lib
