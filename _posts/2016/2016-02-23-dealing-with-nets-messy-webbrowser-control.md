---
layout: default
title: Dealing with .NET's messy WebBrowser control
tags: update
---

I've been trying hard to coax .NET's WebBrowser control to log in using PingFederate federation server. I particularly don't want to mess with the registry to change Internet Explorer's [browser emulation](https://msdn.microsoft.com/en-us/library/ee330730.aspx) settings due to a single application. Something that with Android is [amazingly simple](https://delog.wordpress.com/2016/02/18/tackling-oauth-2-0-in-an-android-app/), requires a lot of [extra effort](http://stackoverflow.com/a/937636/1750924) with .NET for the Desktop.

The WebBrowser control defaults to IE7 emulation as seen by the following User-Agent header, discovered using Fiddler.

```text
User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.2; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729)
```

There's a bug in the browser control that sends a trailing null character in POST data.

```conf
pf.username=xxx&pf.pass=xxx&pf.ok=clicked&pf.cancel=<NULL>
```

I had to extend the WebBrowser control, gain access to its internal ActiveX control, and use events of that control to modify the behavior just enough to be able to log in using PingFederate. The code that does that is reproduced below.

```c#
public class ExtendedWebBrowser : WebBrowser
{
    bool renavigating = false;

    public string UserAgent { get; set; }

    public delegate void BeforeNavigateDelegate(string url, ref bool cancel);

    public event BeforeNavigateDelegate HandleBeforeNavigate;

    public delegate void NavigateErrorDelegate(string url, ref bool cancel);

    public event NavigateErrorDelegate HandleNavigateError;

    public ExtendedWebBrowser()
    {
        DocumentCompleted += SetupBrowser;

        //this will cause SetupBrowser to run (we need a document object)
        Navigate("about:blank");
    }

    void SetupBrowser(object sender, WebBrowserDocumentCompletedEventArgs e)
    {
        DocumentCompleted -= SetupBrowser;
        SHDocVw.WebBrowser xBrowser = (SHDocVw.WebBrowser)ActiveXInstance;
        xBrowser.BeforeNavigate2 += BeforeNavigate;
        xBrowser.NavigateError += NavigateError;
    }

    private void NavigateError(object pDisp, ref object URL, ref object Frame, ref object StatusCode, ref bool Cancel)
    {
        if (HandleNavigateError != null)
            HandleNavigateError.Invoke((string)URL, ref Cancel);
    }

    void BeforeNavigate(object pDisp, ref object url, ref object flags, ref object targetFrameName,
        ref object postData, ref object headers, ref bool cancel)
    {
        if (renavigating)
        {
            renavigating = false;
            if (HandleBeforeNavigate != null)
            {
                HandleBeforeNavigate.Invoke((string)url, ref cancel);
            }
        }
        else
        {
            byte[] pSrc = (byte[])postData;
            byte[] p = pSrc;

            if (pSrc != null && pSrc[pSrc.Length - 1] == 0)
            {
                // remove trailing null from POST data
                p = new byte[((byte[])postData).Length - 1];
                Array.Copy(((byte[])postData), p, p.Length);
                renavigating = true;
            }

            if (!string.IsNullOrEmpty(UserAgent))
            {
                headers += string.Format("User-Agent: {0}\r\n", UserAgent);
                renavigating = true;
            }

            if (renavigating)
            {
                Navigate((string)url, (string)targetFrameName, p, (string)headers);
                cancel = true;
            }
        }
    }
}
```

The authorization code returned by PingFederate can be obtained by registering for HandleNavigateError event. Using the HandleBeforeNavigate event handler does not work, because it is not invoked when the browser control is redirected after a `302` Not Found response.

```c#
extendedWebBrowser1.HandleNavigateError += delegate (string url,
    ref bool cancel)
{
    cancel = ExtractAuthorizationCode(url);
};
```
