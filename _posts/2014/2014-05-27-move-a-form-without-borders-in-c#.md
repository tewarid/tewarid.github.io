---
layout: default
title: Move a form without borders in C#
tags: c# borderless windows forms programming
comments: true
---

The following code snippet that demonstrates how to move around a borderless form, by using the mouse events of the form or other control contained in it. The code assumes you have a form with a label called `label1`, and have hooked the mouse down, mouse move, and mouse up events of the label appropriately.

```c#
bool mouseDown = false;
Point cursorPosition;
Point formLocation;

private void label1_MouseDown(object sender, MouseEventArgs e)
{
    if (e.Button == System.Windows.Forms.MouseButtons.Left)
    {
        cursorPosition = Cursor.Position;
        formLocation = this.Location;
        mouseDown = true;
        label1.Text = string.Format("{0}, {1}", cursorPosition.X, cursorPosition.Y);
    }
}

private void label1_MouseMove(object sender, MouseEventArgs e)
{
    if (mouseDown)
    {
        int x = Cursor.Position.X - cursorPosition.X;
        int y = Cursor.Position.Y - cursorPosition.Y;
        this.Location = new Point(formLocation.X+x, formLocation.Y+y);
        label1.Text = string.Format("{0}, {1}", x, y);
    }
}

private void label1_MouseUp(object sender, MouseEventArgs e)
{
    mouseDown = false;
}
```
