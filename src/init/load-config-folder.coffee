
extend          = require 'util-ex/lib/_extend'
FileConfig      = require './load-config-file'
module.exports  = Config  = require 'load-config-folder'
frontMatterMarkdown = require 'front-matter-markdown'

markdownExts = [
  '.md', '.mdown', '.markdown', '.mkd','.mkdn'
  '.mdwn', '.mdtext','.mdtxt'
  '.text'
]

Config.addConfig ['_config', 'INDEX', 'README', 'SUMMARY', 'index', 'readme']
Config::configurators = extend {}, FileConfig::configurators
Config.register markdownExts, frontMatterMarkdown
