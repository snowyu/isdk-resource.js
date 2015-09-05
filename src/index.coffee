inherits    = require 'inherits-ex'
fs          = require 'graceful-fs'
Resource    = require 'resource-file'
minimatch   = require 'minimatch-ex'
isObject    = require 'util-ex/lib/is/type/object'
isFunction  = require 'util-ex/lib/is/type/function'

require './init/load-config-folder'

fs.cwd      = process.cwd
Resource.setFileSystem fs
path = fs.path


# the src is the file patterns for folder
# the dest is the destination folder.
module.exports = class IsdkResource
  inherits IsdkResource, Resource

  constructor: (aPath, aOptions, done)->
    return new IsdkResource(aPath, aOptions, done) unless @ instanceof IsdkResource
    if isObject aPath
      done = aOptions if isFunction aOptions
      aOptions = aPath
      aPath = undefined
    else if isFunction aOptions
      done = aOptions
      aOptions = null
    aOptions ?= {}
    aOptions.filter = (file)->
      result = !@src
      unless result
        result = minimatch path.relative(file.base, file.path), @src, aOptions
      result
    super aPath, aOptions, done
