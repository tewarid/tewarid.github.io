---
layout: default
title: Stream WebM file to Chrome using Node.js
tags: webm file http stream nodejs
---

Node.js can be used to stream arbitrary data to a browser such as Chrome over HTTP. In this post we'll use latest version of [express](http://expressjs.com/index.html) middleware to stream a WebM file to the browser.

### Install express

Execute the following npm command to install express

```bash
sudo npm install express@latest
```

npm will installs express to a folder called node_modules under the current folder. If you run Node.js in the same folder, it should be able to find express.

### The code

Create a a file `webm.js` with the following code

{% gist 841ac1c6f1aac37ab70d0027702ddf25 %}

The commented headers in the response may be used for additional control. `Transfer-Encoding` header may also be set to `identity`, its default value, as long as the `Connection` response header is set to `close`. If `Connection` header is `keep-alive`, `Transfer-Encoding` has to be `chunked`. This requirement may be specific to Chrome. Chunking is taken care of by Node.js.

### Running the code

To stream a WebM file at `/home/user/file.webm`

```bash
node webm.js 9001 /home/user/file.webm
```

Point Chrome to `http://host:9001/` to play the video.

### Doing it the easy way

express has a method in the response object to send a file, that replaces all the code in the `app.get()` callback above

```javascript
  res.sendfile(file);
```
