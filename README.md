# Deferred Require

To use, run node with the `--harmony_proxies` and `--harmony_collections` flags.

This npm exports a single top-level function. When called with a path, this
function will require the file at the given path as usual, but any `require`
calls *within* that file will return a special deferred objects that delay
actually requiring anything until the required object is used.

## Basic Example

```coffee
# file-1.coffee
deferredRequire = require 'deferredRequire'
foo = deferredRequire('./file-2')

# actually performs the requires in file-2 because of usage
foo()
```

```coffee
# file-2.coffee
bar = require 'huge-expensive-require'
module.exports = -> bar() + 1
```

In `file-2`, we require `huge-expensive-require`, but we don't use its exports
immediately. Because `file-2` is required with `deferredRequire`, we won't
actually perform the expensive require until it is used in file-1.

## Error Handling

Normally, if a required module throws an exception as it's being required it
can be caught by the code doing the requiring. With deferred-require, the
exception might not get thrown until the object is first used. If you want to
catch these exceptions, pass an error handler function to `deferredRequire`.

```coffee
# file-1.coffee
deferredRequire = require 'deferred-require'
deferredRequire './file-2', (error) -> console.warn("Error", e.stack)
```

```coffee
# file-2.coffee
bar = require 'exception-throwing-module'
module.exports = -> bar() + 1
```

## Caveats

This is achieved via ES6 harmony proxies. If your top-level require is an
irregular object such as an array, a Date object, or host object, you may
encounter instability until V8 fully supports these kinds of objects.
