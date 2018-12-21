---
layout: default
title: A simple configuration mechanism in Node.js
tags: config nodejs node javascript json
comments: true
---
# A simple configuration mechanism in Node.js

Node.js provides a neat mechanism to read JSON, you can simply require the JSON file

```javascript
var config = require('./config.json');
console.log(config.db.port);
```

The module system [caches](http://nodejs.org/api/modules.html#modules_caching) the file, so subsequent requires don't parse the file again. If you need to read the file after it has been modified, you'll need to use [require.cache](http://nodejs.org/api/globals.html#globals_require_cache) to delete it before invoking require.

```javascript
delete require.cache('./config.json');
```

You can invoke `require.cache` when the file changes by using the [`watchFile`](http://nodejs.org/api/fs.html#fs_fs_watchfile_filename_options_listener) function exported by the File System module.
