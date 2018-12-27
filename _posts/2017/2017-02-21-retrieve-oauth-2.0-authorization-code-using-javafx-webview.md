---
layout: default
title: Retrieve OAuth 2.0 authorization code using JavaFX WebView
tags: update
comments: true
---
# Retrieve OAuth 2.0 authorization code using JavaFX WebView

This post documents a snippet of code that can be added to Browser class in [JavaFX WebView sample](#webviewsamplejava), to extract OAuth 2.0 authorization code.

Assuming you've configured WebView's WebEngine to load the authorization URL, the authorization service will redirect you to the redirect_uri specified in the authorization URL, after a user logs in successfully. It will pass along the code parameter, that can be extracted as follows

```java
webEngine.locationProperty().addListener((observable, oldValue, newValue) -> {
    String location = (String)newValue;
    int index = location.indexOf("code=");
    if (index >= 0) {
        String code = location.substring(index + 5);
        // TODO wrap up
    }
});
```

## WebViewSample.java

```java
import javafx.application.Application;
import javafx.geometry.HPos;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Region;
import javafx.scene.paint.Color;
import javafx.scene.web.WebEngine;
import javafx.scene.web.WebView;
import javafx.stage.Stage;

public class WebViewSample extends Application {
    private Scene scene;
    @Override public void start(Stage stage) {
        // create the scene
        stage.setTitle("Web View");
        scene = new Scene(new Browser(),750,500, Color.web("#666970"));
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args){
        launch(args);
    }
}

class Browser extends Region {

    final WebView browser = new WebView();
    final WebEngine webEngine = browser.getEngine();

    public Browser() {
        // load the web page
        webEngine.load("https://www.google.com");

        //add the web view to the scene
        getChildren().add(browser);

    }

    private Node createSpacer() {
        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);
        return spacer;
    }

    @Override protected void layoutChildren() {
        double w = getWidth();
        double h = getHeight();
        layoutInArea(browser,0,0,w,h,0, HPos.CENTER, VPos.CENTER);
    }

    @Override protected double computePrefWidth(double height) {
        return 750;
    }

    @Override protected double computePrefHeight(double width) {
        return 500;
    }
}
```
