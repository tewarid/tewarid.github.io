---
layout: default
title: Embedded Linux system for BeagleBoard-xM with Yocto Project
tags: linux yocto beagleboard
comments: true
---
# Embedded Linux system for BeagleBoard-xM with Yocto Project

I've mostly abandoned a BeagleBoard-xM that I have, and am using Raspberry Pi for most of my embedded Linux hacks. I have built a Linux system for BeagleBoard-xM using Yocto Project though, so thought I'd put the instructions out there.

I'm performing the following build on an Ubuntu 14.04 Parallels Desktop 9 VM. The steps below were mostly discovered from the [Yocto Project Quick Start](http://www.yoctoproject.org/docs/1.4/yocto-project-qs/yocto-project-qs.html). Look there if you need further help.

The following dependencies are required on the build machine before you proceed

```

sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath libsdl1.2-dev xterm
```

Next, clone the the dora branch from the git repo of Yocto Project, and prepare the build environment

```

git clone -b dora http://git.yoctoproject.org/git/poky
source poky/oe-init-build-env build
```

You'll be in the the build folder when that is done.

Add the following to conf/local.conf

```

MACHINE ?= "beagleboard"
```

Go ahead and perform the build

```

bitbake core-image-minimal
```

After the build is done, grab and deploy the images from `tmp/deploy/images/beagleboard`.