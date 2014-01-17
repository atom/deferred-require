# Deferred Require

To use, run node with the `--harmony_proxies` and `--harmony_collections` flags.

```coffee
deferredRequire = require 'deferred-require'

bar = null
deferredRequire.run ->
  require 'foo' # no I/O performed
  bar = -> foo() + 1
  
# later...

bar() # actually requires foo here, at first usage
```

Any require performed in a deferred-require block waits to perform I/O until the
required module is first used. This is achieved via ES6 harmony proxies. If your
top-level require is an irregular object such as an array, a Date object, or
host object, you may encounter instability until V8 fully supports these kinds
of objects.
