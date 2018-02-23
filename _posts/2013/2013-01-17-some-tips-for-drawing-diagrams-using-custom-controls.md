---
layout: default
title: Some tips for drawing diagrams using custom controls
tags: windows forms .net c# programming
---

Making diagrams the main UI for your application is easier than it may seem at first. The Windows Forms API provides mechanisms such as [overriding the `OnPaint`](http://msdn.microsoft.com/en-us/library/cksxshce.aspx) method, and drawing primitive shapes using methods of the [`Graphics`](http://msdn.microsoft.com/en-us/library/system.drawing.graphics.aspx) object, that make the task relatively easy.

### Ordering of the controls

The order in which controls are added to the parent control's Controls collection, determines the order in which they'll appear. Thus, if you want to show one control over the other, just change its [ordering](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.controlcollection.setchildindex.aspx) in the [Controls](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.controls.aspx) collection.

### Eliminating flicker

It is possible to get [flicker-free](http://www.codeproject.com/Articles/12870/Don-t-Flicker-Double-Buffer) performance by setting the [`DoubleBuffered`](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.doublebuffered.aspx) property of the UserControls to true. Now, if you go about moving the controls and repainting, you'll see much less flickering.

### Custom Shapes

You can leverage the [`GraphicsPath`](http://msdn.microsoft.com/en-us/library/system.drawing.drawing2d.graphicspath.aspx) class to create custom shapes such as [rectangles with rounded corners](http://www.gutgames.com/post/Drawing-a-Box-With-Rounded-Corners-in-C.aspx).

### Transparent background

A control may have a shape that is not a rectangle, an ellipse for instance. You want to be able to see the controls that are beyond the area of the ellipse. The default behavior is to see a rectangular background even if the region has not been painted by your code. To draw irregularly shaped controls you can set the [`Control.Region`](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.region.aspx) property.

### Moving Controls

Probably the most common need is to move the controls around using the mouse.

This can be done quite simply by handling the [`MouseMove`](http://msdn.microsoft.com/en-us/library/system.windows.forms.control.mousemove.aspx) event and some code

```c#
int newX = control.Left + e.X - xOffset;
newX = newX > 0 ? newX : control.Left;
//newX = newX > this.Width - control.Width ? control.Left : newX;
control.Left = newX;
int newY = control.Top + e.Y - yOffset;
newY = newY > 0 ? newY : control.Top;
//newY = newY > this.Height - control.Height ? control.Top : newY;
control.Top = newY;
```

Uncomment the commented lines of code if you want to restrict the control to the visible area of the parent.

### Reducing speed of movement

If you move your controls around, especially beyond the visible area of the parent control, you'll notice that the controls just zip around at high speed. To make things more usable by us humans, we can limit that rate. This is the same as restricting a game to a certain frame rate. Besides helping the user, restricting the rate also reduces CPU usage by preventing it from doing unnecessary unappreciated work.

This can be achieved by code such as

```c#
int tickCount = Environment.TickCount;
if (tickCount - this.tickCount > 40 || tickCount < this.tickCount)
{
    this.tickCount = tickCount;
}
else
{
    // limit mouse movement
    return;
}
```

Here, we restrict the rate of movement to 25 per second, by ensuring that the event handler for mouse move returns unless 40 milliseconds have elapsed since the last time it did useful work. `Environment.TickCount` property counts the number of milliseconds elapsed since the system was started. We've also considered the fact that `Environment.TickCount` may overflow at some point in time.

### Drawing primitive shapes

The hardest thing I probably had to do is draw a straight line connector between two shapes. It is hard to do because I wanted to place a label on the connector and position it in code. I reproduce the code below as a demonstration of drawing primitive shapes and text.

```c#
void drawConnector(Graphics graphics, UserControl control1, UserControl control2, string text)
{
    int x1 = control1.Left + control1.Width / 2;
    int y1 = control1.Top + control1.Height / 2;
    int x2 = control2.Left + control2.Width / 2;
    int y2 = control2.Top + control2.Height / 2;
    graphics.DrawLine(this.linePen, x1, y1, x2, y2);

    if (text == null) return;

    SizeF size = graphics.MeasureString(text, this.font);

    int x = x1 < x2 ? 
        x1 + (x2 - x1) / 2 - (int)size.Width / 2
        : x2 + (x1 - x2) / 2 - (int)size.Width / 2;

    if (Math.Abs(x1 - x2) < size.Width)
    {
        y1 = y1 < y2 ? y1 + control1.Height / 2 : y1 - control1.Height / 2;
        y2 = y2 < y1 ? y2 + control2.Height / 2 : y2 - control2.Height / 2;
    }

    int y = y1 < y2 ? 
        y1 + (y2 - y1) / 2 - (int)size.Height / 2
        : y2 + (y1 - y2) / 2 - (int)size.Height / 2;

    y = Math.Abs(y1 - y2) < size.Height ? y - (int)size.Height / 2 : y;

    graphics.FillRectangle(Brushes.White, 
        new Rectangle(x, y, 
            (int)size.Width, 
            (int)size.Height - (int)Math.Ceiling(this.linePen.Width)));

    graphics.DrawString(text, this.font, Brushes.Black, x, y);
}
```

### Open issues

I haven't figured out how to draw primitive shapes in the `OnPaint` method of the parent control and have them appear above the child controls. I have seen some workarounds at StackOverflow and elsewhere but nothing elegant. Another thing that I have to figure out is drawing out of the bounds of the child control's region. By default, if the child control wants to show a boundary line around itself it has to paint it within its bounds or else it will be clipped.
