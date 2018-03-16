---
layout: default
title: Use JavaFX in a Swing or console app
tags: update
comments: true
---

This short post explores how to integrate JavaFX into a legacy console or Swing application.

Assuming you've created an application such as the [WebView Sample](https://gist.github.com/tewarid/59c5b91c6c4c89d7beda207144978470), create a separate thread to launch JavaFX's Application class

```java
Thread appThread = new Thread(() -> {
  launch();
});
appThread.start();
```

To allow us to control when JavaFX will exit, disable implicit exit. Implicit exit happens when the last window (Stage) is closed by calling hide() or close(). Add this snippet of code to the start() method to JavaFX's Application class

```java
Platform.setImplicitExit(false);
```

To run code on [JavaFX Application thread](http://www.javaworld.com/article/3057072/learn-java/exploring-javafxs-application-class.html)

```java
Platform.runLater(new Runnable() {
  @Override public void run() {
    // code runs on JavaFX thread
  }
});
```

To exit gracefully when legacy application exits

```java
Platform.exit();
```