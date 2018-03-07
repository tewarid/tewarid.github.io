---
layout: default
title: RunOutputFileVerifyTask compile task in Atmel Studio 6.1
tags: atmel studio
---

Atmel Studio 6.1 has a new `RunOutputFileVerifyTask` task that fails the build when the binary exceeds memory limit of the target board. This is a very useful check but can be a pain on certain occasions. It is fairly easy to disable though. Edit the `Compiler.targets` file under [Atmel Studio 6.1 install folder]\vs and comment all elements where `RunOutputFileVerifyTask` appears, including `UsingTask` at the beginning.
