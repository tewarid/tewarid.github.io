---
layout: default
title: Retrieve OAuth 2.0 authorization code using JavaFX WebView
tags: update
comments: true
---

This post documents a snippet of code that can be added to Browser class in [JavaFX WebView sample](https://gist.github.com/tewarid/59c5b91c6c4c89d7beda207144978470), to extract OAuth 2.0 authorization code.

Assuming you've configured WebView's WebEngine to load the authorization URL, the authorization service will redirect you to the redirect_uri specified in the authorization URL, after a user logs in successfully. It will pass along the code parameter, that can be extracted as follows

{% gist 57031d4b2f0a27765fa82abd10c21351 %}