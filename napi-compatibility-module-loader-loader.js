console.warn("Loading node-napi-compatibility-module");
b=process.env.NAPI_INSTALL_DIR;
b=b+"/napi-compatibility-module-loader.node";
a=require(b);
delete a;
delete b;
