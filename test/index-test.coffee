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
    if i.isDirectory() and i.content
      result.push v = {}
      v[i.inspect()] = buildTree(i.contents, [])
    else
      result.push i.inspect()
  result

describe 'ISDKResource', ->
  testPath = __dirname+'/fixture'
  it 'should init', ->
    expect(loadCfgFile::fs).to.be.equal fs
    expect(loadCfgFolder::fs).to.be.equal fs

  it 'should create a resource object', ->
    result = Resource testPath, ->
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    expect(result.contents).to.have.length 3

  it 'should create a resource object and filter', ->
    result = Resource '.', src: '*.js',cwd:testPath
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    result = buildTree result.contents, []
    expect(result).to.be.deep.equal [ '<File? "index.js">' ]

  it 'should create a resource object and filter2', ->
    result = Resource path:'.', src: '**/*.js',cwd:testPath, ->
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    result = buildTree result.contents, []
    expect(result).to.be.deep.equal [ '<File? "index.js">' ]

  it 'should create a resource object and filter3', ->
    result = Resource path:'.', src: ['**/*.js', '**/'],cwd:testPath, ->
    expect(result).have.ownProperty 'filter'
    expect(result.filter).to.be.a 'function'
    result.loadSync read:true
    result = buildTree result.contents, []
    expect(result).to.be.deep.equal [ '<Folder? "folder">', '<File? "index.js">' ]

  describe 'indexOfSync', ->
    it 'should indexof a file contents', ->
      file = Resource path:'./folder/README.md', cwd:testPath
      result = file.indexOfSync 'config'
      expect(file.contents.toString().slice(result, result+6)).be.equal 'config'

    it 'should indexof a folder contents', ->
      file = Resource path:'.', cwd:testPath
      result = file.indexOfSync 'test'
      result = file.contents[result]
      expect(result.basename.indexOf('test')).to.be.at.least 0

  describe 'indexOf', ->
    it 'should indexof a file contents', (done)->
      file = Resource path:'./folder/README.md', cwd:testPath
      file.indexOf 'config', (err, result)->
        unless err
          expect(file.contents.toString().slice(result, result+6)).be.equal 'config'
        done(err)

    it 'should indexof a folder contents', (done)->
      file = Resource path:'.', cwd:testPath
      file.indexOf 'test', (err, result)->
        unless err
          result = file.contents[result]
          expect(result.basename.indexOf('test')).to.be.at.least 0
        done(err)
