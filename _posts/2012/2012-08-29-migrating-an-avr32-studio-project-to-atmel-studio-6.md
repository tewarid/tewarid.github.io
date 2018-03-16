---
layout: default
title: Migrating an AVR32 Studio project to Atmel Studio 6
tags: atmel avr studio
comments: true
---

Atmel has at two IDEs that I know of

* A cross-platform, Eclipse based, AVR32 Studio.

* A Windows only, [Visual Studio Isolated Shell](http://msdn.microsoft.com/en-us/library/bb685691.aspx) based, Atmel Studio 6.

### Migrate AVR32 Studio project

I am studying migrating from AVR32 Studio to Atmel Studio 6. Luckily, migration is made painless in Atmel Studio 6 due to the import option under the File menu. You can specify the location of your AVR32 Studio workspace, tell the import wizard to find/list projects under the workspace, and select all projects you want to migrate. The wizard does in-place migration, so backup your work before running the wizard. It shouldn't mess anything up but you never know. The tool creates a solution file in the workspace folder, and a project file with the extension `cproj` under each project.

I had to eliminate the compiler option `-march=ucr1` to proceed with the build - GCC compiler with the newer toolchain refuses to compile with message _Conflicting architectures implied by -mpart and -march_.

### Missing linker flags after migration

I did find one minor issue after migration. My project uses a linker script to place code and data in flash and SRAM. The linker flag `-T` used to specify the [linker script](http://sourceware.org/binutils/docs/ld/Scripts.html#Scripts) was not migrated over. The same thing happened with the flag [`-Wl,-e`](http://sourceware.org/binutils/docs/ld/Entry-Point.html) that is used specify the entry point. I had to add these manually to project settings in the Linker flags text box under Toolchain, AVR32/GNU Linker, Miscellaneous.

One last thing I had to do was exclude the linker script from compilation, otherwise the build fails.

### Using the older Toolchain

The biggest problem I faced was post build. The target board would reset on executing the code. GCC version that ships with Atmel Studio 6 is 4.4.3 (AVR_32_bit_GNU_Toolchain_3.4.0_332). Whereas, the GCC version that ships with AVR32 Studio 2.6 is 4.3.3 (AVR_Toolchain_3.0_124). Similarly, GNU ld is also newer. I confirmed toolchain was the culprit, by creating a Flavour Configuration (accessible from under menu Tools, Options...) that points to the toolchain provided with AVR32 Studio, and changing the project settings to that flavor from the Advanced tab. I still haven't figure out what is wrong with the new toolchain.

### Atmel Studio 6 on Windows 8

I have been able to successfully install it on Windows 8. The only hassle being the following message a short while after launch

```text
Could not connect to the local debug agent. Make sure avrdbg.exe is started and not blocked by firewall or antivirus program.
```

You'll find instructions to get the debugger working again [here](https://avrstudio5.wordpress.com/2012/05/17/running-atmel-studio-6-0-in-windows-8/). Atmel Studio 6.1 update works out of the box.

### Going back to AVR32 Studio 2.6

Fairly straight forward, just fire it up. The only issue I found is that it fails to detect USB drivers for AVR debuggers.

It shows the following  message

```text
The USB drivers required for communicating with AVR debuggers such AVR ONE!, JTAGICE mkII and AVR Dragon do no appear to be installed.
```

The solution is to uninstall the updated driver and install the older one. This is not required after the Atmel Studio 6.1 update, both IDEs coexist well.
