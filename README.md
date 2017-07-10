# node-napi-compatibility-module
This retrofits N-API module compatibility to node.js 4.X and 6.X

**Warning, the node N-API is still experimental and so is not yet API/ABI stable. Use at your own risk. You may end up having to rebuild any addons you build using the experimental N-API.** 

The N-API implemenation in this repo is based on a slightly modified version of the N-API implementation provided here: https://github.com/nodejs/node-addon-api/ (based off commit b0f2c6fe59d08f2b0c0bd44a43f3362640b84059)

Purpose
-------

Currently node.js binary native addons need to be recompiled against each major release of node.js. The node.js N-API is intended to resolve this issue by providing an API and ABI stable interface for writing node.js binary addons. This allows the same binary addons to work across multiple versions of node.js . 

This ``node-napi-compatibility-module`` adds the ability to load unmodified N-API addon binaries to node.js 4.X and node.js 6.X . This allows you to build N-API addon binaries with, say, node.js 8.X (tested with 8.1.3) and use those same binaries in node.js 4.X or 6.X

Building
--------

This has only been tested to work on Linux systems. I tested the code against node.js 4.8.3 on Ubuntu 14.04 (x64, though in theory x86 should also work). Will not work on Windows yet.

Make sure you install node-gyp using:

```npm install -g node-gyp```

Next set ``MY_GYP_DIR`` in ``mk`` to wherever node.js has installed the ``node-gyp`` headers etc. Then run:

```./mk```


Using
-----

Once ``mk`` has been run the built copy of ``node-napi-compatibility-module`` will be in the directory called ``install`` . To use ``node-napi-compatibility-module`` add ``node-napi`` to your path:

```export PATH=${PWD}/install/bin:$PATH```

you must also add ``install/lib`` to your ``LD_LIBRARY_PATH`` :

```export LD_LIBRARY_PATH=${PWD}/install/lib:$LD_LIBRARY_PATH``` 

You should then be able to use N-API modules using the ``node-napi`` wrapper:

```node-napi my_file.js```

Test Suite
----------
There is a rough test suite in the ``test`` directory. To use it go in to the ``test/addons-napi`` directory. These are tests ported across from the node.js 8.1.3 source tree (plus some hacked up bits of the node.js 4.8.3 tree) . At the moment tests are run manually by descending in to each directory and running the ``./mk`` command with ``sh ./mk`` and then running ``node-napi --expose-gc ./test.js``. A return code of 0 indicates a test pass. This is still WIP. I'll put together a proper test runner at some point

Limitations
-----------

* In node.js 4.X ``node-napi`` will not load the ``node-napi-compatibility-module`` when in REPL mode (ie when starting ``node-napi`` with no scripts as arguments). If you wish to use ``node-napi-compatibility-module`` with the REPL you must manually ``require`` it. Doesn't seem to affect node.js 6.X

* Spawned processes will not inherit N-API support (eg processes spawned by ``process.spawn``). Similar to the upstream issue with ``--napi-modules`` (https://github.com/nodejs/abi-stable-node/issues/164).  In node.js 8.X they work around that using ``NODE_OPTIONS`` . Unfortunately ``NODE_OPTIONS`` doesn't seem to be available with node.js 4.X or 6.X . Maybe that will be backported some point.
