# node-napi-compatibility-module
This retrofits N-API module compatibility to node.js 4.X and 6.X

**Warning, the node N-API is still experimental and so is not yet API/ABI stable. Use at your own risk. You may end up having to rebuild any addons you build using the experimental N-API.** 

The N-API implemenation in this repo is based on a slightly modified version of the N-API implementation provided here: https://github.com/nodejs/node-addon-api/

Purpose
=======

Currently node.js binary native addons need to be recompiled against each major release of node.js. The node.js N-API is intended to resolve this issue by providing an API and ABI stable interface for writing node.js binary addons. This allows the same binary addons to work across multiple versions of node.js . 

Building
========

This has only been tested to work on Linux systems. I tested the code against node.js 4.8.3 on Ubuntu 14.04 (x64, though in theory x86 should also work). Will not work on Windows yet.

Make sure you install node-gyp using:

```npm install -g node-gyp```

Next set ``MY_GYP_DIR`` in ``mk`` to wherever node.js has installed the ``node-gyp`` headers etc. Then run:

```./mk```

Using
=====

Once ``mk`` has been run the built copy of node-napi-compatibility-module will be in the directory called ``install`` . To use node-napi-compatibility-module add ``node-napi`` to your path:

```export PATH=${PWD}/install/bin:$PATH```

you must also add ``install/lib`` to your ``LD_LIBRARY_PATH`` :

```export $LD_LIBRARY_PATH=${PWD}/install/lib:$LD_LIBRARY_PATH``` 

You should then be able to use N-API modules using the ``node-napi`` wrapper:

```node-napi my_file.js```

Limitations
===========

In node.js 4.X ``node-napi`` will not load the node-napi-compatibility-module when in REPL mode (ie when starting ``node-napi`` with no scripts as arguments). If you wish to use node-napi-compatibility-module with the REPL you must manually ``require`` it.
