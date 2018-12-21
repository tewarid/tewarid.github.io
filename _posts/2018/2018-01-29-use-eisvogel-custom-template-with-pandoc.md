---
layout: default
title: Use eisvogel custom template with Pandoc
tags: ctan tlmgr eisvogel pandoc macos linux markdown
comments: true
---
# Use eisvogel custom template with Pandoc

On macOS, the preinstalled tlmgr command is used to install $$\TeX$$ packages from [CTAN](https://ctan.org/).

To list currently installed packages

```bash
tlmgr list --only-installed
```

To update tlmgr itself - you won't be able to install packages unless you do

```bash
sudo tlmgr update --self
```

To install packages required by the [eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) $$\LaTeX$$ template for Pandoc

```bash
sudo tlmgr install csquotes mdframed needspace sourcesanspro ly1 mweights sourcecodepro titling pagecolor
```

The command needs to be run with sudo because the path where $$\TeX$$ and associated packages are installed is at `/usr/local/texlive/2016basic/texmf-dist/tex` and does not have write permission for my user.

To use the eisvogel template, clone its repo

```bash
git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git
```

To render PDF, in the folder cloned above, run

```bash
pandoc file.md -f gfm -o file.pdf --template ./eisvogel.tex --variable titlepage=true
```

Remove the `--variable titlepage=true` option if you don't want a title page.