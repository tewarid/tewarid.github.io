---
layout: default
title: Lua dofile and globals
tags: lua programming
comments: true
---

I have been doing dissector development for Wireshark in Lua for a while now. Lua's mechanism for reusing code organized across multiple files comes in two flavors, `dofile` and [`require`](http://www.lua.org/pil/8.1.html). For historical reasons, we've been using `dofile` quite exclusively.

Our dissector files mostly contain global functions, and local or global tables. The tables are used to determine which function should be called to dissect a particular message, to look-up names that map to particular key values, and so on. If a script file needs a function or table in another file, we simply `dofile` the other file at the top. Lua interpreter will recognize all globals (functions and variables without `local`) of the other file from that point onwards.

Let's consider an example. Here's `file1.lua`

```lua
function f1()
  print("f1 called")
  f2()
end

dofile("file2.lua")

f1()
```

Here's `file2.lua`, located in the same folder as `file1.lua`

```lua
function f2()
  print("f2 called")
end
```

When you run `file1.lua`, this is what you get

```lua
$ lua file1.lua
f1 called
f2 called
```

Lua only encounters call to global `f2` inside function `f1` when we call function `f1` towards the end of `file1.lua`. If we call `f1` right at the beginning of `file1.lua` we get

```bash
$ lua file1.lua
lua: file1.lua:2: attempt to call global 'f1' (a nil value)
stack traceback:
    file1.lua:2: in main chunk
    [C]: in ?
```

If we move `dofile` towards the end of `file1.lua` we get

```bash
$ lua file1.lua
f1 called
lua: file1.lua:3: attempt to call global 'f2' (a nil value)
stack traceback:
    file1.lua:3: in function 'f1'
    file1.lua:7: in main chunk
    [C]: in ?
```

Summing it up, a global exists only when Lua has encountered it, whether within the same or another script file.

Let us explore one other characteristic of `dofile` with another example. This is `file1.lua`

```lua
dofile("file2.lua")
hello['world'] = 'hello!'
print(hello['world'])

function f1()
  print(hello['world'])
  f3()
end

dofile("file3.lua")

f1()
```

It requires a certain global table in `file2.lua`, which it updates before using. It also requires a certain function `f3` in `file3.lua`. This is `file2.lua`

```lua
hello = {['hello']='world!'}

function f2()
  print("f2 called")
end
```

This is `file3.lua`

```lua
dofile('file2.lua')

function f3()
  print('f3 called')
  f2()
end
```

It needs function `f2` in `file2.lua`. You shouldn't need `dofile` because `file1.lua` has already loaded `file2.lua`, but whoever coded `file3.lua` probably doesn't know that. Let's execute `file1.lua` and see what happens

```bash
$ lua file1.lua
hello!
nil
f3 called
f2 called
```

By the time function `f1` gets called, the value of key `'world'` in the `hello` table ceases to exist. Why? Because, right before `f1` is called, when we `dofile` `file3.lua` it will `dofile` `file2.lua`. Since `file2.lua` gets interpreted again, the global hello is replaced by a new table.

Summing it up, Lua will load and execute the same file again when it encounters `dofile`, redefining all globals in it.

That is why, for reusing code in other script files, use `require`. Lua will not reinterpret a script file that has already been encountered before. Modifying the example scripts above is straightforward. Replace all `dofile` with `require` and drop the lua extension. Thus `dofile('file2.lua')` will become `require('file2')`.

Execute `file1.lua` thus

```bash
$ export LUA_PATH=$PWD/?.lua
$ lua file1.lua
hello!
hello!
f3 called
f2 called
```

Globals now work without side-effects! Note the use of LUA_PATH environment variable to specify the search path for Lua scripts. You can also set search path inside a Lua script by modifying package.path.

What if you have already invested in `dofile` and don't want to change things for now? In the example above, modifying `file2.lua` thus, eliminates our problem

```lua
if hello == nil then hello = { } end
hello['hello']='world!'

function f2()
  print("f2 called")
end
```
