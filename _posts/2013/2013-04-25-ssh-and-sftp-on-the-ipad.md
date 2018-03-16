---
layout: default
title: SSH and SFTP on the iPad
tags: ssh ftp sftp app ipad
comments: true
---

I am using [Termius](https://itunes.apple.com/br/app/server-auditor-ssh-client/id549039908?l=en&mt=8) (previously called ServerAuditor), a wonderful and free SSH terminal app, on my iPad to access a Linux box. I needed to get the text contents (certificate) of a pem file into the app for authentication. I originally received the file by e-mail and had no app that would open the pem extension.

After some fruitless attempts, I realized that the iPad has absolutely no app to view arbitrary text files. Browsers such as Chrome and Safari will only allow opening files with extensions they already understand.

After some searching I discovered that the Mercury Browser allows you to download files with any extension and upload them to Dropbox. It does not however allow viewing of arbitrary files, nor does Dropbox. Dropbox does allow you to view text files but will not allow you to rename a file so that it has the extension `txt`. I then remembered that [Documents by Readdle](https://itunes.apple.com/br/app/documents-by-readdle/id364901807?l=en&mt=8) allows you to rename files in Dropbox, and discovered that its built-in browser (Mobile Safari for all purposes) allows downloading files.

So there you go - I accessed my GMail account using Documents, downloaded the file with pem extension, changed its extension to `txt` and was able to copy its contents to the Termius app. You don't really have to rename the file since Documents will gladly show you its contents despite the pem extension. Did I mention that it also has SFTP support and allows you to edit files on the server?
