#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#include <node.h>

namespace demo {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::Object;
using v8::String;
using v8::Value;

void Method(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  args.GetReturnValue().Set(String::NewFromUtf8(isolate, "world"));
}

void init(Local<Object> exports) {
  void *handle;

  handle = dlopen ("napi-compatibility-module.so", RTLD_NOW | RTLD_GLOBAL);
  if (!handle) {
    fputs (dlerror(), stderr);
    exit(1);
  }
  NODE_SET_METHOD(exports, "hello", Method);
}

NODE_MODULE(napi_compatibility_module_loader, init)

}  // namespace demo
