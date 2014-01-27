deferredRequire = require '../src/deferred-require'

describe "deferredRequire", ->
  it "allows requiring of objects to be deferred", ->
    module = deferredRequire './fixtures/object'
    expect(module.foo).toBe 'bar'

  it "allows requiring of constructors to be deferred", ->
    Constructor = deferredRequire './fixtures/constructor'
    object = new Constructor
    expect(object.calledConstructor).toBe true

  it "allows an error handler to be specified in case requiring the module throws an exception", ->
    errorHandler = jasmine.createSpy("handler").andReturn(foo: 'baz')
    module = deferredRequire './fixtures/exception-thrower', errorHandler
    expect(errorHandler).not.toHaveBeenCalled()
    expect(module.foo).toBe 'baz'
    expect(errorHandler).toHaveBeenCalled()
