---
layout: default
title: JSON syntax highlighting in ScintillaNET
tags: update
comments: true
---
# JSON syntax highlighting in ScintillaNET

I am studying the excellent [ScintillaNET](https://www.nuget.org/packages/jacobslusser.ScintillaNET/) code editing component, to enable basic JSON editing in a .NET application.

Inspired by the [C# code highlighting](https://github.com/jacobslusser/ScintillaNET/wiki/Automatic-Syntax-Highlighting) example, here's the code snippet to enable basic JSON syntax highlighting

```c#
// Configure the JSON lexer styles
scintilla.Styles[Style.Json.Default].ForeColor = Color.Silver;
scintilla.Styles[Style.Json.BlockComment].ForeColor = Color.FromArgb(0, 128, 0); // Green
scintilla.Styles[Style.Json.LineComment].ForeColor = Color.FromArgb(0, 128, 0); // Green
scintilla.Styles[Style.Json.Number].ForeColor = Color.Olive;
scintilla.Styles[Style.Json.PropertyName].ForeColor = Color.Blue;
scintilla.Styles[Style.Json.String].ForeColor = Color.FromArgb(163, 21, 21); // Red
scintilla.Styles[Style.Json.StringEol].BackColor = Color.Pink;
scintilla.Styles[Style.Json.Operator].ForeColor = Color.Purple;
scintilla.Lexer = Lexer.Json;
```

![net-scintilla-json.png](/assets/img/net-scintilla-json1.png)
