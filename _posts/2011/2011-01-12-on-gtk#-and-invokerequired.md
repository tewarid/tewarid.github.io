---
layout: default
title: On GTK# and InvokeRequired
tags: c# gtk invoke required user interface race condition .net
comments: true
---
# On GTK# and InvokeRequired

Most user interface code is not thread safe. If multiple threads change UI components, unexpected things may happen. .NET Windows Forms programmers are familiar with the [InvokeRequired](https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.control.invokerequired) property present in all controls.

It is common to find code of the following kind in callback methods

```c#
private void MyCallback()
{
  if (!InvokeRequired)
  {
     // do something useful
  }
  else
  {
    Invoke(new MethodInvoker(delegate
    {
      // Anonymous delegate
      // Things to do in the UI thread
    }));
  }
}
```

In GTK# this works slightly differently. To queue work to the UI thread use the static method `Add` from the [`Idle`](http://docs.go-mono.com/index.aspx?link=T:GLib.Idle) class in the `GLib` namespace.

Here's an example

```c#
private void MyCallback()
{
  GLib.Idle.Add(new IdleHandler(MyHandler));
}
private bool MyHandler()
{
  // do something useful
  return false; // return true if the idle handler must be called again
}
```

GTK# 2 has another method that can be used with anonymous delegates, `Gtk.Application.Invoke`. Its usage is described in the article [Responsive Applications](https://www.mono-project.com/docs/gui/gtksharp/responsive-applications/).
