inherits    = require 'inherits-ex'
fs          = require 'graceful-fs'
Resource    = require 'resource-file'
minimatch   = require 'minimatch-ex'
isObject    = require 'util-ex/lib/is/type/object'
isFunction  = require 'util-ex/lib/is/type/function'
isArray     = require 'util-ex/lib/is/type/array'

require './init/load-config-folder'

fs.cwd      = process.cwd
fs.path     = path = require 'path.js'
Resource.setFileSystem fs

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
        vPath = path.relative(file.base, file.path)
        vPath += path.sep if file.stat.isDirectory()
        result = minimatch vPath, @src, aOptions
      result
    super aPath, aOptions, done

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

  _findSync: (aContents, aSearchValue, aFile)->
    if isArray aContents
      aFromIndex = 0 unless aFromIndex >= 0
      vDirs = []
      for i in [aFromIndex...aContents.length]
        file = aContents[i]
        if file.relative.indexOf(aSearchValue) isnt -1
          result = file
          break
        vDirs.push file if file.isDirectory()
      while !result and vDirs.length
        file = vDirs.pop()
        result = file.findSync aSearchValue
    else if aContents
      i = aContents.toString().indexOf(aSearchValue, aFromIndex)
      result = i if i isnt -1
    result

  _find: (aContents, aSearchValue, aFile, done)->
    if isArray aContents
      aFromIndex = 0 unless aFromIndex >= 0
      vDirs = []
      for i in [aFromIndex...aContents.length]
        file = aContents[i]
        if file.relative.indexOf(aSearchValue) isnt -1
          result = file
          break
        vDirs.push file if file.isDirectory()
      if !result and vDirs.length
        file = vDirs.pop()
        vDirFindFn = (err, result)->
          return done(err, result) if err or result? or !vDirs.length
          file = vDirs.pop()
          file.find aSearchValue, vDirFindFn
          return
        file.find aSearchValue, vDirFindFn
        return
      done(null, result)
      return
    else if aContents
      i = aContents.toString().indexOf(aSearchValue, aFromIndex)
      result = i if i isnt -1
    done(null, result)

  findSync: (aSearchValue)->
    contents = @loadSync(read:true)
    @_findSync contents, aSearchValue, @

  find: (aSearchValue, done)->
    that = @
    @load read:true, (err, contents)->
      return done(err) if err
      that._find contents, aSearchValue, that, done
      return
    @
