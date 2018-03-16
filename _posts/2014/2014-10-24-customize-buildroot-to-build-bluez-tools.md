---
layout: default
title: Customize Buildroot to build bluez-tools
tags: bluez tools buildroot custom package linux raspberry pi
comments: true
---

I am building Bluetooth support into my custom embedded Linux system with Buildroot, but couldn't find basic command line tools that work with newer versions of BlueZ. That is when I came across [bluez-tools](https://code.google.com/p/bluez-tools/), a GSoC project that is able to fill the gap.

To build bluez-tools requires [adding](https://buildroot.org/downloads/manual/manual.html#adding-packages) my own package to Buildroot. What follows is a brief description of how to do that.

Download source code of bluez-tools. I did this outside of the buildroot folder, by cloning from the author's GitHub repo

```bash
git clone https://github.com/khvzak/bluez-tools.git
```

Add an override rule to file local.mk, in the root folder of buildroot. That tells Buildroot not to download package source from the internet, but to copy the source from the folder created above

```conf
BLUEZ_TOOLS_OVERRIDE_SRCDIR = /home/parallels/github/bluez-tools/
```

Create a folder for bluez-tools package

```bash
mkdir package/bluez-tools
```

Create package/bluez-tools/bluez-tools.mk file for the package with

```conf
################################################################################
#
---
layout: default
title: bluez-tools
tags:
---
#
################################################################################

BLUEZ_TOOLS_DEPENDENCIES = dbus libglib2 readline
BLUEZ_TOOLS_AUTORECONF = YES

$(eval $(autotools-package))
```

BLUEZ_TOOLS_AUTORECONF tells buildroot to generate configure script and Makefile.in by invoking autoconf et al.

Create configuration file package/bluez-tools/Config.in for the package with

```conf
config BR2_PACKAGE_BLUEZ_TOOLS
    bool "bluez-tools"
    help
      This is a GSoC'10 project to implement a new command line tools for bluez (bluetooth stack for linux). The project implemented in C and uses the D-Bus interface of bluez. 

      https://code.google.com/p/bluez-tools/
```

Add the package to package/Config.in

```bash
source "package/bluez-tools/Config.in"
```

Enter configuration menu and select the package

```bash
make menuconfig
```

![bluez-tools](/assets/img/buildroot-packages-bluez-tools.png)

Note that bluez-tools package is under Networking applications because I added it to menu "Networking applications" in package/Config.in

Invoke make to perform the build

```bash
make
```

If you get any build errors try

```bash
make clean
make
```

make clean will delete Linux kernel config. Either save the config, or do it all over again.

With Buildroot 2015.05, a command such as

```bash
bt-adapter -l
```

Fails with

```text
bt-adapter: bluez service is not found
Did you forget to run bluetoothd?
```

bluetoothd is running just fine. Got to figure that one out.

It works all right with Buildroot 2014.08, but have noted the following issue with bt-device

```text
---
layout: default
title: bt-device -c 5C:0E:8B:03:6E:4E
tags:
---
Connecting to: 5C:0E:8B:03:6E:4E
Device: CS3070:10172522500886 (5C:0E:8B:03:6E:4E)
Enter passkey: 1234
Segmentation fault
```

Debugging with gdb reveals the following backtrace

```text
#0  0xb6e77d00 in g_utf8_validate () from /usr/lib/libglib-2.0.so.0
#1  0xb6e7b5c8 in g_variant_new_string () from /usr/lib/libglib-2.0.so.0
#2  0x0000c0b8 in _bt_agent_method_call_func (connection=<optimized out>,
    sender=<optimized out>, object_path=<optimized out>,
    interface_name=<optimized out>, method_name=0x18fc228 "RequestPinCode",
    parameters=0x1905f00, invocation=0x18fdab0, user_data=0x0)
    at lib/agent-helper.c:310
```

Analyzing lib/agent-helper.c indicates a possible cause, passkey is being read into an uninitialized gchar pointer

```c
            g_print("Enter passkey: ");
            errno = 0;
            if (scanf("%s", &ret) == EOF && errno)
                g_warning("%s\n", strerror(errno));
            g_dbus_method_invocation_return_value(invocation, g_variant_new_string(ret));
```

Should not be hard to fix.

bt-network crashes when used thus

```bash
bt-network -c C8:3E:99:C6:1B:F8 panu
```

Backtrace with gdb appears thus

```text
#0  0xb6ec7ec8 in g_bit_lock () from /usr/lib/libglib-2.0.so.0
#1  0xb6f240a0 in g_variant_n_children () from /usr/lib/libglib-2.0.so.0
#2  0xb6f24100 in g_variant_get_child_value () from /usr/lib/libglib-2.0.so.0
#3  0x000192e8 in network_connect (self=self@entry=0x14d3470, 
    uuid=0xbef76e9e "panu", error=error@entry=0xbef76be4)
    at lib/bluez/network.c:178
#4  0x0000a3bc in main (argc=0, argv=0x14e5128) at bt-network.c:186
```

Analyzing the source code reveals another possible bug

```c
        GVariant *proxy_ret = g_dbus_proxy_call_sync(self->priv->proxy, "Connect", g_variant_new ("(s)", uuid), G_DBUS_CALL_FLAGS_NONE, -1, NULL, error);
        if (proxy_ret != NULL)
                return NULL;
        proxy_ret = g_variant_get_child_value(proxy_ret, 0);
```
