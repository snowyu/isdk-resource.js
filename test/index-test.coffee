chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

setImmediate    = setImmediate || process.nextTick

Resource        = require '../src'
fs              = require 'graceful-fs'
loadCfgFile     = require 'load-config-file'
loadCfgFolder   = require 'load-config-folder'

buildTree = (aContents, result)->
  aContents.forEach (i)->
    if i.isDirectory()
      result.push v = {}
      v[i.inspect()] = buildTree i.contents, []
    else
      result.push i.inspect()
  result

describe 'ISDKResource', ->

  it 'should init', ->
    expect(loadCfgFile::fs).to.be.equal fs
    expect(loadCfgFolder::fs).to.be.equal fs

  it.only 'should create a resource object', ->
    result = Resource '.', ->
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    expect(result.contents).to.have.length 15

  it 'should create a resource object and filter', ->
    result = Resource '.', src: '**/*.js'
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    result = buildTree result.contents, []
    expect(result).to.be.deep.equal [ '<File? "index.js">' ]

  it 'should create a resource object and filter2', ->
    result = Resource path:'.', src: '**/*.js', ->
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    result = buildTree result.contents, []
    expect(result).to.be.deep.equal [ '<File? "index.js">' ]
