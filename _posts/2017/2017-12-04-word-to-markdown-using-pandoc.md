---
layout: default
title: Word to Markdown using Pandoc
tags: word markdown pandoc
---

Markdown has become the de-facto standard for [writing software documentation](https://www.amazon.com/Modern-Technical-Writing-Introduction-Documentation-ebook/dp/B01A2QL9SS). This post discusses converting Word documents to Markdown using Pandoc, and rendering them to PDF.

To follow along, if you haven't done so already, [install](https://pandoc.org/installing.html) Pandoc. Word documents need to be in the [docx](http://www.ecma-international.org/publications/standards/Ecma-376.htm) format. Legacy binary doc files are not supported by Pandoc.

Pandoc supports several flavors of Markdown such as the popular [GitHub flavored Markdown](https://github.github.com/gfm/) (GFM). To produce a standalone GFM document from docx, run

```bash
pandoc -t gfm --extract-media . -o file.md file.docx
```

The `--extract-media` option tells Pandoc to extract media to a `./media` folder.

## Render PDF

To render a PDF using Pandoc

```bash
pandoc file.md -f gfm -o file.pdf --toc -N
```

Remove `--toc` option if you don't want a table of contents. Remove `-N` option if you don't want sections to be numbered automatically.

## Markdown Editor

You'll need a text editor to edit a Markdown file. I use Visual Studio Code (Code) which has built-in support for editing and previewing Markdown files. I use a few additional plugins to make editing Markdown files more productive

* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
* [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
* [Markdown TOC](https://marketplace.visualstudio.com/items?itemName=AlanWalk.markdown-toc)
* [Markdown Shortcuts](https://marketplace.visualstudio.com/items?itemName=mdickin.markdown-shortcuts)
* [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
* [SpellChecker](https://marketplace.visualstudio.com/items?itemName=swyphcosmo.spellchecker)
* [Table Formatter](https://marketplace.visualstudio.com/items?itemName=shuworks.vscode-table-formatter)

## Tables

Pandoc will convert Word tables whose cells have a single line of text using the pipe table syntax. Column text alignment is not rendered, you'll have to add that back. Relative column widths may need to be adjusted using dashes.

Tables whose cells have complex data such as lists and multiple lines, are converted to the HTML table syntax. It is not unusual for tables with complex layouts such as merged cells to be missing columns or rows. _Review all tables carefully_. I suggest simplifying complex tables in the original Word document before conversion.

HTML tables in Markdown are not rendered to PDF, and pipe table cells with long text, or images, may [stretch beyond the page](https://github.com/jgm/pandoc/issues/4239). I've obtained nice results using grid tables in Pandoc's native Markdown format, but these tables are not rendered in Markdown preview in Code, GitHub, and GitLab.

## Table of Contents

Pandora dumps the table of contents (TOC) of the original docx a line per topic. It renders section headings without numbering. I suggest eliminating the TOC, and letting Pandoc number sections, and render table of contents, automatically.

If you have cross-references in the Word document using section numbers, you can generate a hyperlinked TOC using the capabilities of Markdown TOC plugin of Code. The plugin can also add, update, or remove section numbering.

I suggest you avoid section numbers and use hyperlinked section references instead.

## Images

Images are exported in their native format and size. They are inserted in the document using the `![[caption]](path)` GFM syntax. Image sizes cannot be customized in GFM syntax. Pandoc's Markdown syntax allows setting image attributes such as width using the `![[caption]](path){key1=value1 key2=value2}` syntax.

## Figures

Pandoc is unable to render diagrams created using Word's figures and shapes. You'll need to screen capture the output rendered by Word. I suggest using the SVG format for figures, and edit and render them to images using editors such as [SVG-edit](https://github.com/SVG-Edit/svgedit).

You can use [mermaid.js](https://mermaidjs.github.io/) syntax to recreate diagrams such as flowcharts and message sequence charts, embed in Markdown document, and render using [mermaid-filter](https://github.com/raghur/mermaid-filter)

```bash
pandoc file.md -f gfm -o file.pdf --toc -N -F mermaid-filter
```

GitHub doesn't render mermaid diagrams in its [Markdown preview](https://github.com/github/markup). Code is able to render them using the Markdown Preview Mermaid Support plugin. GitLab version 10.3 is also able to render them in its Markdown preview.

## Captions

Pandoc converts captions in the docx to plain text that appears after an image or table. Figure and table numbers are sometimes missing, I suggest you review all captions and references.

## Cross-references

GFM does not natively support linking to figures and tables, and HTML anchors are not a viable option with Pandoc. I suggest using Pandoc's native Markdown syntax for adding captions, and linking to the section containing a figure or table.

## Large Documents

Pandoc can handle large documents that have hundreds of pages. You may want to maintain large document in separate Markdown files for productivity and reuse, and to save users from long wait times when previewing documents at GitHub or GitLab. Previewing may fail entirely on complex documents. You may want to pre-render such documents to HTML using Pandoc.

Pandoc can render multiple Markdown files into a single document

```bash
pandoc overview.md body.md appendix.md -f gfm -o file.pdf --toc -N
```

## Regular Expressions

Using [regular expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions) will significantly speed up your ability to do bulk search and replace operations.

Some useful regular expressions for searching

* `^#+\s*$` empty heading
* `\s+$` line with trailing spaces
* `\b\s\s+\b` repeated whitespace between words
* `\s+[,;.]` whitespace before , or .
* `\n\n[a-z]` paragraph starts with small case
* `figure\s+(?!([\d]){1,})` word figure not followed by a number
* `section\s+(?!(\d+\.*\d*?){1,})` word section not followed by number