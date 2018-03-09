---
layout: default
title: Quickly create Markdown table in Visual Studio Code
tags: pandoc grid table visual studio code plugin markdown
---

Here's a badly formatted table that is syntactically correct

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

The table uses grid [table syntax](https://pandoc.org/MANUAL.html#tables), but the same procedure can be used with pipe tables.

Use Code's [Table Formatter](https://marketplace.visualstudio.com/items?itemName=shuworks.vscode-table-formatter) plugin to format the table so it looks like

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

This is how the grid table should look when rendered to PDF using the eisvogel latex template

![Grid Table rendered to PDF by Pandoc](/assets/img/pandoc-pdf-grid-table.png)
