---
layout: default
title: Implement a color picker using ComboBox
tags: windows forms .net c# programming
---

This post shows how you can custom draw items of a [`ComboBox`](http://msdn.microsoft.com/en-us/library/system.windows.forms.combobox.aspx) to implement a color picker. The implementation is mostly inspired by a [CodeProject article](http://www.codeproject.com/Articles/34332/Color-Picker-Combo-Box), but I had to adapt the code for the color bands to show adequately.

### Register for DrawItem event

Here's how you can register for [`DrawItem`](http://msdn.microsoft.com/en-us/library/system.windows.forms.combobox.drawitem.aspx). The event handler is called for each item that the ComboBox requires painting. The first line enables custom drawing.

```c#
combobox.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawVariable;
combobox.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.eventhandler);
```

### Event handler implementation

Here's one simple implementation for the event handler:

```c#
private void eventhandler(object sender, DrawItemEventArgs e)
{
    if (e.Index < 0) return;

    Graphics g = e.Graphics;
    Rectangle rect = e.Bounds;
    string n = ((ComboBox)sender).Items[e.Index].ToString();
    Font f = new Font("Arial", 9, FontStyle.Regular);
    Color c = Color.FromArgb((int)colors[e.Index]);
    Brush b = new SolidBrush(c);
    g.FillRectangle(Brushes.White, rect);
    g.DrawString(n, f, Brushes.Black, rect.X, rect.Top);
    g.FillRectangle(b, rect.X + 110, rect.Y + 3,
                    rect.Width - 113, rect.Height - 6);
}
```

Here's one example of the colors and colorNames arrays used above:

```c#
uint[] colors =
    {
        0xFFCD853F, 0xFFDEB887, 0xFFF08080, 0xFFFF0000, 
        0xFF969696, 0xFF00FF7F, 0xFF90EE90, 0xFF00FFFF, 
        0xFF48D1CC, 0xFFBA55D3, 0xFFF0E68C, 0xFFFFD700
    };
string[] colorNames =
    {
        "Peru", "Burlywood", "Light coral", "Red",
        "Lime", "Spring green", "Light green", "Cyan",
        "Medium turquoise", "Medium orchid", "Khaki", "Gold"
    };
```

You can [pick colors](http://web.forret.com/tools/color_palette.asp) of your own choice.

### Locating a color and setting its index

Here's one way to locate the index of a color by its ARGB value, and set the SelectedIndex property of the ComboBox:

```c#
for (int i = 0; i < colors.Length; i++)
{
    if (colors[i] == (uint)color.ToArgb())
    {
        combobox.SelectedIndex = i;
    }
}
```

Here, color is an instance of the [`Color`](http://msdn.microsoft.com/en-us/library/system.drawing.color.aspx) structure.
