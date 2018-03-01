---
layout: default
title: Quickly create Markdown table in Visual Studio Code
tags: pandoc grid table visual studio plugin markdown
---

This is how you can create badly formatted table that is syntactically correct, using Pandoc's grid [table syntax](https://pandoc.org/MANUAL.html#tables)

```text
: Table caption

+-+-+
| header 1 | header 2 |
+=+=+
| - row 1, col 1, line 1 | row 1, col 2 |
| - row 1, col 2, line 2 | |
+-+-+
| - row 2, col 1 | row 2, col 2 |
+-+-+
```

Then, use Code's [Table Formatter](https://marketplace.visualstudio.com/items?itemName=shuworks.vscode-table-formatter) plugin to format it so it looks like

```text
: Table caption

+------------------------+--------------+
|        header 1        |   header 2   |
+========================+==============+
| - row 1, col 1, line 1 | row 1, col 2 |
| - row 1, col 2, line 2 |              |
+------------------------+--------------+
| - row 2, col 1         | row 2, col 2 |
+------------------------+--------------+
```

The same procedure can be used with pipe tables.

This is how the grid table looks when rendered to PDF

![Grid Table rendered to PDF by Pandoc](/assets/img/pandoc-pdf-grid-table.png)
