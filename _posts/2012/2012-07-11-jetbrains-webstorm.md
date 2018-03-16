---
layout: default
title: JetBrains WebStorm
tags: web ide html
comments: true
---

After a hiatus of almost eight years I have returned to doing development of web apps. The first thing I started searching for is a decent IDE. My search revealed Visual Studio .NET 2010, which I already had installed, JetBrains [WebStorm](http://www.jetbrains.com/webstorm) 4, which I am now evaluating, and [Aptana](http://www.aptana.com/products/studio3.html) Studio 3, a free alternative.

Visual Studio .NET 2010 does have nice HTML WYSIWYG editing and CSS support, but you quickly realize that it has less than stellar support for code editing. Compared to code editing capabilities for .NET languages, the editor for HTML and JavaScript is poor.

Aptana Studio 3 is awesome for its price. It has a nice code editor with syntax highlighting and auto-completion. It tends to freeze occasionally when certain features are loaded for the first time, but is otherwise quite responsive.

None of the these compare to the joy that is WebStorm.

I'll quickly highlight what I like about it

1. You can create projects, but can just as well point to the root folder of your HTML code and are good to go. Couldn't be simpler. It supports commonly used version control repositories, including SVN and Git.

2. Auto-completion in HTML, JavaScript and CSS works really well. HTML auto-completion even works in JavaScript strings.

3. Quickly find (control+click) where a CSS style or JavaScript function is defined, and used (Alt+F7). Really nice to gain a big picture understanding of a (rather messy) code base. Jump to files using the same method.

4. Refactor (rename, move, delete...) files, class names, JavaScript functions and so on. Really nice for making sweeping changes with ease. I did encounter a few rough edges. For instance, I found it impossible to rename a class when multiple class names are specified e.g. `<div class="class1 class2">`.

5. Code analysis points out errors and possible solutions. It even has a built-in spellchecker.

6. Unit test and debug JavaScript step-by-step in Chrome or FireFox.

7. Fast and responsive, I have yet to have it freeze on me.

Check out their [features page](http://www.jetbrains.com/webstorm/features/) for other neat things it can do. I have yet to think of what I don't like about WebStorm.

Don't have the money to spend on a personal license, and your company will not sponsor a license? You can get a much reduced set of features with the [IntelliJ IDEA Community Edition](http://www.jetbrains.com/idea/), a nice free IDE for anything Java, including Android.
