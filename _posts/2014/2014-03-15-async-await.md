---
layout: default
title: async await
tags:
---

async/await makes asynchronous programming tremendously easy, that is, if you are a .NET programmer. It has taken me a while to get around to learning to use them. I wanted to share their power with a simple example, based on a Windows Forms app that has just two buttons. One button does something, the other cancels it. 

Here's the source code in C#

```c#
CancellationTokenSource source;

private void doSomethingButton_Click(object sender, EventArgs e)
{
    source = new System.Threading.CancellationTokenSource();
    CancellationToken token = source.Token;
    DoSomethingAsync(token);
}

async void DoSomethingAsync(CancellationToken token)
{
    // invoke not required, we are still in the main thread
    doSomethingButton.Enabled = false;

    // do other quick work here...

    int count = 0;

    // this is where we depart from the main thread
    await System.Threading.Tasks.Task.Run(delegate
    {
        for (count = 0; count < 1000000000; count++) 
            if (token.IsCancellationRequested) break;
    });

    // invoke not required, we are back to the main thread
    MessageBox.Show(String.Format("Counted till {0}", count));
    doSomethingButton.Enabled = true;
}

private void cancelButton_Click(object sender, EventArgs e)
{
    source.Cancel();
}
```

Clicking on `doSomethingButton` invokes event handler `doSomethingButton_Click`, where we create a `CancellationTokenSource` and pass its `CancellationToken` to method `DoSomethingAsync`. The latter is adorned with `async`. In it, we create a long running Task (worker thread) at some point, that will end either when we are done, or when cancellation is requested by clicking `cancelButton`. The method itself returns to `doSomethingButton_Click` at the point it encounters the `await` keyword. An interesting bit of trickery happens at that point. All the statements that follow `await` will run in the original thread's context when the Task is done. Pretty neat, isn't it?

If you want to convert your synchronous code to asynchronous, I recommend reading [Best Practices in Asynchronous Programming](https://msdn.microsoft.com/en-us/magazine/jj991977.aspx).
