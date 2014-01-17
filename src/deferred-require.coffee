require 'harmony-reflect'
Module = require 'module'

originalRequire = Module::require

module.exports = (parentPath, errorHandler) ->
  try
    Module::require = (path) -> Proxy(new RequireTarget(this, path, errorHandler), RequireHandler)
    module = originalRequire.call(module, parentPath)
  finally
    Module::require = originalRequire
  module

class RequireTarget
  constructor: (@parentModule, @path, @errorHandler) ->

  getModule: ->
    @module ?= @requireModule()

  requireModule: ->
    if @errorHandler?
      try
        originalRequire.call(@parentModule, @path)
      catch e
        @errorHandler(e)
        {}
    else
      originalRequire.call(@parentModule, @path)

RequireHandler =
  get: (target, name, receiver) ->
    Reflect.get(target.getModule(), name, receiver)

  set: (target, name, receiver) ->
    Reflect.set(target.getModule(), name, receiver)

  has: (target, name) ->
    Reflect.has(target.getModule(), name)

  apply: (target, receiver, args) ->
    Reflect.apply(target.getModule(), receiver, args)

  construct: (target, args) ->
    Reflect.construct(target.getModule(), args)

  getOwnPropertyDescriptor: (target, name, desc) ->
    Reflect.getOwnPropertyDescriptor(target.getModule(), name, desc)

  defineProperty: (target, name, desc) ->
    Reflect.defineProperty(target.getModule(), name, desc)

  getPrototypeOf: (target, name, desc) ->
    Reflect.getPrototypeOf(target.getModule(), name, desc)

  setPrototypeOf: (target, newProto) ->
    Reflect.setPrototypeOf(target.getModule(), newProto)

  deleteProperty: (target, name) ->
    Reflect.deleteProperty(target.getModule(), name)

  enumerate: (target) ->
    Reflect.enumerate(target.getModule())

  preventExtensions: (target) ->
    Reflect.preventExtensions(target.getModule())

  isExtensible: (target) ->
    Reflect.isExtensible(target.getModule())

  ownKeys: (target) ->
    Reflect.ownKeys(target.getModule())

  hasOwn: (target, name) ->
    Reflect.hasOwn(target.getModule(), name)

  getOwnPropertyNames: (target) ->
    Reflect.getOwnPropertyNames(target.getModule())

  keys: (target) ->
    Reflect.keys(target.getModule())

  freeze: (target) ->
    Reflect.freeze(target.getModule())

  seal: (target) ->
    Reflect.seal(target.getModule())

  isFrozen: (target) ->
    Reflect.isFrozen(target.getModule())

  isSealed: (target) ->
    Reflect.isSealed(target.getModule())

  iterate: (target) ->
    Reflect.iterate(target.getModule())
