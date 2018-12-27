---
layout: default
title: Stream WebM file to Chrome using Node.js
tags: webm file http stream nodejs gstreamer
comments: true
---
# Stream WebM file to Chrome using Node.js

Node.js can be used to stream arbitrary data to a browser such as Chrome over HTTP. In this post we'll use latest version of [express](http://expressjs.com/index.html) middleware to stream a WebM file to the browser.

## Install express

Execute the following npm command to install express

```bash
sudo npm install express@latest
```

npm will installs express to a folder called node_modules under the current folder. If you run Node.js in the same folder, it should be able to find express.

## The code

Create a a file `webm.js` with the following code

```javascript
var fs = require('fs');
var util = require('util');

if (process.argv.length != 4) {
  console.log('Require the following command line arguments:' +
    ' http_port webm_file');
  console.log(' e.g. 9001 /home/foo/file.webm');
  process.exit();
}

var port = process.argv[2];
var file = process.argv[3];

var express = require('express')

var app = express();

app.get('/', function(req, res){
  console.log(util.inspect(req.headers, showHidden=false, depth=0));

  var stat = fs.statSync(file);
  if (!stat.isFile()) return;

  var start = 0;
  var end = 0;
  var range = req.header('Range');
  if (range != null) {
    start = parseInt(range.slice(range.indexOf('bytes=')+6,
      range.indexOf('-')));
    end = parseInt(range.slice(range.indexOf('-')+1,
      range.length));
  }
  if (isNaN(end) || end == 0) end = stat.size-1;

  if (start > end) return;

  console.log('Browser requested bytes from ' + start + ' to ' +
    end + ' of file ' + file);

  var date = new Date();

  res.writeHead(206, { // NOTE: a partial http response
    // 'Date':date.toUTCString(),
    'Connection':'close',
    // 'Cache-Control':'private',
    // 'Content-Type':'video/webm',
    // 'Content-Length':end - start,
    'Content-Range':'bytes '+start+'-'+end+'/'+stat.size,
    // 'Accept-Ranges':'bytes',
    // 'Server':'CustomStreamer/0.0.1',
    'Transfer-Encoding':'chunked'
    });

  var stream = fs.createReadStream(file,
    { flags: 'r', start: start, end: end});
  stream.pipe(res);
});

app.listen(port);

process.on('uncaughtException', function(err) {
  console.log(err);
});
```

The commented headers in the response may be used for additional control. `Transfer-Encoding` header may also be set to `identity`, its default value, as long as the `Connection` response header is set to `close`. If `Connection` header is `keep-alive`, `Transfer-Encoding` has to be `chunked`. This requirement may be specific to Chrome. Chunking is taken care of by Node.js.

## Running the code

To stream a WebM file at `/home/user/file.webm`

```bash
node webm.js 9001 /home/user/file.webm
```

Point Chrome to `http://host:9001/` to play the video.

## Doing it the easy way

express has a method in the response object to send a file, that replaces all the code in the `app.get()` callback above

```javascript
  res.sendfile(file);
```
