# Deferred Require

**Using this module requires that you run node with the `--harmony_proxies` and
`--harmony_collections` flags.**

```coffee
deferredRequire = require 'deferred-require'
myHugeModule = require 'my-huge-module'

# ... some time later ...

myHugeModule.doSomething() # the module isn't loaded and required until here
```

This npm exports a single top-level function, `deferredRequire`, which you can
use just as you would use node's global `require` function. When you require a
module with `deferredRequire`, no code is actually loaded or evaluated until
the module you require is first used. This is achieved through the magic of
harmony proxies.

Warning: Because of instability in the v8 proxy implementation when combined
with "exotic objects" like arrays, strings, and dates, you should only use
`deferredRequire` with modules that export regular objects or functions as their
top-level module. This is true of almost every npm module, so in practice this
shouldn't be a big issue.
