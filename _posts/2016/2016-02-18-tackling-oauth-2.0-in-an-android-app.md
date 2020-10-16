---
layout: default
title: Tackling OAuth 2.0 in an Android app
tags: oauth2 android
comments: true
---
# Tackling OAuth 2.0 in an Android app

This post shows you how to perform OAuth 2.0 authorization grant flow in an Android app using WebView, without the need to bring up a web server to receive the authorization code.

[OAuth 2.0](https://tools.ietf.org/html/rfc6749) defines a two-step process for obtaining an access token from an identity service, that can subsequently be used to obtain resources from resource servers that trust the identity service.

1. The step to obtain authorization code from identity service is usually carried out once, within the browser, to mitigate the need for user credentials to be handled by clients. The user authenticates with the identity service and authorizes requested scopes. The identity service grants an authorization code as a result, and redirects the browser to a redirect URI specified by the client.

2. Client uses the authorization code obtained through previous step, and performs a token request to identity service with its own credentials in client_id and client_secret. This step usually happen in a server application, but here it's done in an Android app. Some OAuth 2.0 providers enable a simpler implicit grant flow, where step 1 above returns an access token, dispensing the need for step 2.

Here's one way to carry out Step 1 in a WebView

```java
// define REDIRECT_URI
final WebView webView = (WebView)findViewById(R.id.webView);
WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
WebViewClient webViewClient = new WebViewClient() {
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (url.startsWith(REDIRECT_URI)) {
            Pattern p = Pattern.compile(".+code=(.+?(?=&|$))");
            Matcher m = p.matcher(url);
            if (m.matches()) {
                acquireAccessToken(m.group(1));
                // update UI
            }
            return true; // we've handled the url
        } else {
            return false;
        }
    }
};
webView.setWebViewClient(webViewClient);
// Prepare authorization code request url ...
webView.loadUrl(loginURL);
```

I intercept browser navigation using shouldOverrideUrlLoading. Upon detecting the redirect URI, I look for the authorization code, extract it using a simple regular expression, and initiate the procedure to obtain the access token, as described in step 2\. It can be carried out using a simple REST request such as

```java
private void acquireAccessToken(String code) {
    AsyncTask task = new AsyncTask<Object, Integer, String>() {
        @Override
        protected String doInBackground(Object[] urls) {
            return executeRequest((String) urls[0], "POST", "");
        }

        @Override
        protected void onPostExecute(String result) {
            try {
                JSONObject json = new JSONObject(result);
                String accessToken = (String)json.get("access_token");
            } catch(Exception ex) {
                Log.e(TAG, "Request failed.", ex);
            }
        }
    };
    // Prepare token request url...
    task.execute(tokenUrl);
}
```

To perform the HTTP POST request above, I use the HttpsURLConnection class, in the executeRequest convenience method, implemented as follows

```java
private String executeRequest(String url, String method, String content) {
    StringBuilder buffer = new StringBuilder();
    try {
        URL connUrl = new URL(url);

        HttpsURLConnection conn = (HttpsURLConnection)connUrl.openConnection();
        conn.setSSLSocketFactory(sslContext.getSocketFactory());

        if (content != null) {
            conn.setRequestMethod(method);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Content-Length", String.valueOf(content.length()));
            OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
            for (int i = 0; i < content.length(); i++)
                writer.write(content.charAt(i));
        }

        InputStreamReader reader = new InputStreamReader(conn.getInputStream());
        int c = reader.read();
        while (c != -1) {
            buffer.append((char)c);
            c = reader.read();
        }

        conn.disconnect();
    } catch (Exception ex) {
        Log.e(TAG, "Request failed.", ex);
    }
    return buffer.toString();
}
```

Since my identity service creates secure sockets using certificates signed by custom certification authorities, I have need for a custom SSLContext that can perform SSL handshake using pinned CA certificates.

This is how sslContext used above may be initialized

```java
// Create a KeyStore containing our trusted CAs,
// see http://developer.android.com/training/articles/security-ssl.html
String keyStoreType = KeyStore.getDefaultType();
KeyStore keyStore = KeyStore.getInstance(keyStoreType);
keyStore.load(null, null);
CertificateFactory cf = CertificateFactory.getInstance("X.509");
Certificate ca = cf.generateCertificate(getResources().openRawResource(R.raw.cert_1));
keyStore.setCertificateEntry("ca1", ca);
ca = cf.generateCertificate(getResources().openRawResource(R.raw.cert_2));
keyStore.setCertificateEntry("ca2", ca);

// Create a TrustManager that trusts the CAs in our KeyStore
String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
tmf.init(keyStore);

TrustManager[] trustManagers = tmf.getTrustManagers();
sslContext = SSLContext.getInstance("TLS");
sslContext.init(null, trustManagers, null);
```

Certificates are packaged as raw resources under res folder. Android has special naming restrictions for raw resource file names - it only allows lower-case letters and underscores. Binary DER or corresponding textual PEM certificates work fine.
