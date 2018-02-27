---
layout: default
title: OAUTH 2 with google-oauth-java-client
tags: google oauth2 oauth java
---

This post is a quick reference for running the [dailymotion-cmdline-sample](https://github.com/google/google-oauth-java-client/tree/master/samples/dailymotion-cmdline-sample), a Java console sample app for the [google-oauth-java-client](https://github.com/google/google-oauth-java-client) OAUTH 2 library.

The sample app performs [authorization code grant](https://tools.ietf.org/html/rfc6749#section-4.1) specified in the OAUTH 2 RFC, and receives user's authorization code via an embedded Jetty HTTP server. That code is then exchanged for an access token.

Clone the google-oauth-java-client repo at GitHub

```bash
git clone git@github.com:google/google-oauth-java-client.git
```

Install Apache Maven if you don't already have it. You'll need Oracle's JDK to use Maven and compile the sample app. On macOS, Maven can be installed using Homebrew

```bash
brew install maven
```

Head into the cloned repo and compile

```bash
cd google-oauth-java-client
mvn compile
```

Head into the sample app folder and execute the sample app

```bash
cd samples/dailymotion-cmdline-sample
mvn -X exec:java -Dexec.mainClass="com.google.api.services.samples.dailymotion.cmdline.DailyMotionSample"
```

The first execution will fail. You'll need to create a dailymotion.com developer account, which can be created at http://www.dailymotion.com/profile/developer. Create a new API key. The only value that really matters is the Callback URL which should be http://127.0.0.1:8080/Callback.

Enter your API credentials in file `OAuth2ClientCredentials.java`. Compile and exec again. The application should list your favorite videos if all goes well.