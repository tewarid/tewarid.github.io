---
layout: default
title: Pandoc Lua filter to convert Math block type
tags: pandoc math inline block filter lua
comments: true
---
# Pandoc Lua filter to convert math block type

I've been using Markdown for writing text, and  converting it to different formats such as HTML and PDF. One consequence of this is that I have to live with differences between different converters such as Pandoc, I use to render HTML and PDF, and Kramdown, used by Jekyll to render this page.

One particular difference is related to how you insert math using $$\LaTeX$$. Whereas Pandoc expects you to insert inline math between `$` signs, Kramdown expects you to use `$$`. Pandoc understands math between `$$` as block math syntax and it will add a line break before and after the math. The math still gets rendered nicely but messes with the vertical flow of the text.

Since all the math I use is inline, I wrote a simple Pandoc filter in Lua to force any math block to be inline

```lua
function Math(meta)
    --print(meta.mathtype.." "..meta.text)
    -- force InlineMath
    meta.mathtype = "InlineMath"
    return meta
end
```

Assuming the code above is saved to a file called `filter.lua`, you can tell Pandoc to use the filter by adding `--lua-filter filter.lua` to its command line.

If you do want to display math in its own block, you can create a paragraph containing just the math

$$\LaTeX$$

Pandoc filters to the rescue!
