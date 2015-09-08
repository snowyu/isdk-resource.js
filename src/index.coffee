inherits    = require 'inherits-ex'
fs          = require 'graceful-fs'
Resource    = require 'resource-file'
minimatch   = require 'minimatch-ex'
isObject    = require 'util-ex/lib/is/type/object'
isFunction  = require 'util-ex/lib/is/type/function'
isArray     = require 'util-ex/lib/is/type/array'

require './init/load-config-folder'

fs.cwd      = process.cwd
Resource.setFileSystem fs
path = fs.path


# the src is the file patterns for folder
# the dest is the destination folder.
module.exports = class IsdkResource
  inherits IsdkResource, Resource

  _indexOf: (aContents, aSearchValue, aFromIndex)->
    if isArray aContents
      aFromIndex = 0 unless aFromIndex >= 0
      result = -1
      for i in [aFromIndex...aContents.length]
        file = aContents[i]
        if file.relative.indexOf(aSearchValue) isnt -1
          result = i
          break
    else
      result = aContents.toString().indexOf aSearchValue, aFromIndex
    result
  indexOfSync: (aSearchValue, aFromIndex)->
    contents = @loadSync(read:true)
    @_indexOf contents, aSearchValue, aFromIndex

  indexOf: (aSearchValue, aFromIndex, done)->
    if isFunction(aFromIndex)
      done = aFromIndex
      aFromIndex = 0
    @load read:true, (err, contents)->
      unless err
        result = @_indexOf contents, aSearchValue, aFromIndex
      done(err, result)
      return
    @
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
        vPath = path.relative(file.base, file.path)
        vPath += path.sep if file.stat.isDirectory()
        result = minimatch vPath, @src, aOptions
      result
    super aPath, aOptions, done
