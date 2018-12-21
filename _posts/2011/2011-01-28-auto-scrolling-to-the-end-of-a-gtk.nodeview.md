---
layout: default
title: Auto scrolling to the end of a Gtk.NodeView
tags: auto scroll gtk c# .net
comments: true
---
# Auto scrolling to the end of a Gtk.NodeView

Here is how you can add an item to a `NodeView` and auto-scroll right to it. I'll assume you have read this [tutorial](http://www.mono-project.com/GtkSharpNodeViewTutorial) and are not a total newcomer to NodeView.

Using the example from the tutorial, here is how you auto-scroll to the item just added

```c#
MyTreeNode node = new MyTreeNode ("The Beatles", "Yesterday");
view.NodeStore.AddNode(node);
view.ScrollToCell(new TreePath(new int[] {_n-1}), null, false, 0, 0);
```

Here, `_n` is the number of rows you have in the `NodeStore`. It can be a private attribute that should be incremented by 1 when a new row is added, and decremented when a row is removed.

That's all there is to it!
