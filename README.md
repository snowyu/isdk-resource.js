## isdk-resource [![npm](https://img.shields.io/npm/v/isdk-resource.svg)](https://npmjs.org/package/isdk-resource)

[![Build Status](https://img.shields.io/travis/snowyu/isdk-resource.js/master.svg)](http://travis-ci.org/snowyu/isdk-resource.js)
[![Code Climate](https://codeclimate.com/github/snowyu/isdk-resource.js/badges/gpa.svg)](https://codeclimate.com/github/snowyu/isdk-resource.js)
[![Test Coverage](https://codeclimate.com/github/snowyu/isdk-resource.js/badges/coverage.svg)](https://codeclimate.com/github/snowyu/isdk-resource.js/coverage)
[![downloads](https://img.shields.io/npm/dm/isdk-resource.svg)](https://npmjs.org/package/isdk-resource)
[![license](https://img.shields.io/npm/l/isdk-resource.svg)](https://npmjs.org/package/isdk-resource)


The ISDKResource inherits from [resource-file][resource-file].

* It adds the `src` property which is the file patterns to filter the files.
* It registers the [yaml][yaml] configuration format to the ISDKResource.
* It registers the `'index'`, `'readme'`, `'_config'` basename as the folder configuration file.
* It binds the [graceful-fs][graceful-fs] as the file system.
* It binds the `process.cwd` to get the current working directory.

## Usage

```coffee
ISDKResource  = require 'isdk-resource'

```

## API


## TODO


## License

MIT

[resource-file]: https://github.com/snowyu/resource-file.js
[yaml]: http://yaml.org/
[graceful-fs]: https://github.com/isaacs/node-graceful-fs
