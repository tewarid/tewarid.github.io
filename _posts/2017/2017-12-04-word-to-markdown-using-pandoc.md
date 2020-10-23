---
layout: default
title: Word to Markdown using Pandoc
tags: word markdown pandoc
comments: true
---
# Word to Markdown using Pandoc

Markdown has become the _de-facto_ standard for [writing software documentation](https://www.amazon.com/Modern-Technical-Writing-Introduction-Documentation-ebook/dp/B01A2QL9SS). This post documents my experience using Pandoc to convert Word documents (docx) to markdown.

To follow along, [install](https://pandoc.org/installing.html) Pandoc, if you haven't done so already. Word documents need to be in the [docx](http://www.ecma-international.org/publications/standards/Ecma-376.htm) format. Legacy binary doc files are not supported.

Pandoc supports several flavors of markdown such as the popular [GitHub flavored Markdown](https://github.github.com/gfm/) (GFM). To produce a standalone GFM document from docx, run

```bash
pandoc -t gfm --extract-media . -o file.md file.docx
```

The `--extract-media` option tells Pandoc to extract media to a `./media` folder.

## Creating a PDF

To create a PDF, run

```bash
pandoc file.md -f gfm -o file.pdf --toc -N
```

Pandoc requires $$LaTeX$$ to produce the PDF. Remove `--toc` option if you don't want Pandoc to create a table of contents (TOC). Remove `-N` option if you don't want it to number sections automatically.

## Markdown Editor

You'll need a text editor to edit a markdown file. I use vscode. It has built-in support for editing and previewing markdown files. I use a few additional plugins to make editing markdown files more productive

* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

* [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

* [Markdown+Math](https://marketplace.visualstudio.com/items?itemName=goessner.mdmath)

* [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)

* [Markdown Shortcuts](https://marketplace.visualstudio.com/items?itemName=mdickin.markdown-shortcuts)

* [Markdown TOC](https://marketplace.visualstudio.com/items?itemName=AlanWalk.markdown-toc)

* [Markdown Table Formatter](https://marketplace.visualstudio.com/items?itemName=fcrespo82.markdown-table-formatter)

## HTML in Markdown

GFM allows [HTML blocks](https://github.github.com/gfm/#html-blocks) in markdown. These get rendered when previewed in vscode, GitHub, or GitLab. Pandoc suppresses raw HTML output to PDF format and hence HTML blocks get rendered as plain text. For example, `<sup>1</sup>` gets rendered as $$1$$ instead of $$^1$$. You can use `^text^` in Pandoc's markdown syntax to render superscript.

You can use [HTML character entities](https://dev.w3.org/html5/html-author/charref) to write out characters and symbols not available on the keyboard.

## Tables

Pandoc converts docx tables whose cells contain a single line of text each, to the pipe table syntax. Column text alignment is not rendered&mdash;you can add that back using colons. Relative column widths can be specified using dashes. Pipe table cells with long text or images, may [stretch beyond the page](https://github.com/jgm/pandoc/issues/4239).

Tables in docx that have complex data in cells such as lists and multiple lines, are converted to HTML table syntax. That is highly unfortunate because Pandoc renders HTML tables to PDF as plain text.

It is not unusual for docx tables, with complex layouts such as merged cells, to be missing columns or rows. I suggest simplifying such tables, in the original docx, before conversion.

_Review all tables very carefully!_

I've obtained nice results with Pandoc's grid table syntax, but these tables cannot be previewed in vscode, GitHub, or GitLab.

## Table of Contents

Pandora converts TOC in docx as a sequence of lines, where each line corresponds to a topic or section. Section headings are generated without numbering. I suggest deleting the TOC, and using the command line options discussed earlier to number sections and to render TOC.

If you have cross-references in docx that use section numbers, you can generate a hyperlinked TOC using the Markdown TOC plugin of vscode. The plugin can also add, update, or remove section numbers.

I suggest avoiding section numbers for cross-referencing and using hyperlinked section references instead.

## Images

Images are exported to their native format and size. They are rendered in GFM using the `![[caption]](path)` syntax. Image sizes cannot be customized in GFM syntax, but Pandoc's markdown syntax allows setting image attributes such as width using the `![[caption]](path){key1=value1 key2=value2}` syntax.

## Figures

Pandoc does not convert vector diagrams created using Word's figures and shapes. You'll need to screen grab, or copy and paste, the image rendered by Word.

You can use [mermaid.js](https://mermaidjs.github.io/) syntax to recreate diagrams such as flowcharts and message sequence charts. mermaid.js syntax can be embedded in markdown, and converted using [mermaid-filter](https://github.com/raghur/mermaid-filter)

```bash
pandoc file.md -f gfm -o file.pdf --toc -N -F mermaid-filter
```

GitHub [doesn't yet](https://github.com/github/markup/issues/533) allow you to preview mermaid.js diagrams, but GitLab does. vscode is able to preview them using the Markdown Preview Mermaid Support plugin.

## Captions

Pandoc converts captions in the docx as plain text positioned after an image or table. I suggest using Pandoc's native markdown syntax for captions.

## Cross-references

GFM does not natively support linking to figures and tables, and HTML anchors are not a viable option with Pandoc. Link to the section containing a figure or table when referencing it from other parts of the document.

Figure and table numbers in docx may sometimes go missing from cross-references.

_I suggest reviewing captions and cross-references very carefully!_

## Large Documents

Pandoc can handle large documents that have hundreds of pages. You may want to maintain large documents in separate markdown files. This makes concurrent editing productive and allows for reuse. It also allows for faster previews on GitHub or GitLab. In fact, previewing may entirely fail to work for complex documents. You may want to pre-render such documents to HTML using Pandoc.

Pandoc is capable of converting multiple markdown files

```bash
pandoc overview.md body.md appendix.md -f gfm -o file.pdf --toc -N
```

## Regular Expressions

Using [regular expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions) significantly speeds up your ability to search and replace text. Some examples follow

* Empty heading

    `^#+\s*$`

* Line with trailing spaces

    `\s+$`

* Repeated whitespace between words

    `\b\s\s+\b`

* Whitespace before , or .

    `\s+[,;.]`

* Paragraph starts with small case

    `\n\n[a-z]`

* Word _figure_ not followed by a number

    `figure\s+(?!([\d]){1,})`

* Word _section_ not followed by a number

    `section\s+(?!(\d+\.*\d*?){1,})`
