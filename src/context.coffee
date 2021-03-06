# Context - control logic binding context

## Context Object
debug = require('debug')('yang:context') if process.env.DEBUG?
delegate = require 'delegates'
proto = module.exports = {
  inspect: -> @toJSON()
  toJSON: -> @property?.valueOf()
  throw: (err) ->
    err = new Error err unless err instanceof Error
    err.context = this
    throw err
  with: (state={}) -> @state[k] = v for own k, v of state; this
  defer: (data) ->
    debug? "deferring '#{@path}' until update"
    debug? data
    @root.once 'update', =>
      debug? "applying deferred data (#{typeof data}) into #{@path}"
      debug? data
      @content = data
    return data
  debug: -> debug? arguments...
}

## Property delegation
delegate proto, 'property'
  .method 'get'
  .method 'find'
  .method 'in'
  .method 'once'
  .method 'on'
  .access 'content'
  .getter 'schema'
  .getter 'container'
  .getter 'parent'
  .getter 'name'
  .getter 'kind'
  .getter 'path'
  .getter 'root'

## State delegation
delegate proto, 'state'
  .access 'input'
  .access 'output'

## Module delegation
delegate proto, 'root'
  .method 'access'
  .method 'enable'
  .method 'disable'
  .access 'engine'
