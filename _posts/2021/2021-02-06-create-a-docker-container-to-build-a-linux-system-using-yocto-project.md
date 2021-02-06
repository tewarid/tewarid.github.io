---
layout: default
title: Create a Docker container to build a Linux system using Yocto Project
tags: yocto linux kernel raspberry pi docker
comments: true
---
# Create a Docker container to build a Linux system using Yocto Project

The last time I posted about [building a Linux system for a Raspberry Pi using the Yocto project]({% link _posts/2014/2014-09-16-embedded-linux-system-for-raspberry-pi-with-yocto-project.md %}), I used a Linux Virtual machine on macOS. Docker has since become quite popular and is often used to build embedded Linux systems. In this post, I document how to create a Docker container to run the build in the aforementioned post, on macOS, but Linux and Windows should work similarly.

To create the container, we'll start with the ubuntu:20.04 base image available at Docker Hub

```bash
docker run --name yoctopi -it -v ${PWD}:/workdir ubuntu:20.04 /bin/bash
```

We've mapped `/workdir` in the container to the current directory, in case you want to copy files in or out of the container. You cannot build in that directory because Yocto requires a case-sensitive file system.

Now that we've created the container and are in its terminal, we can install dependencies needed to run Yocto

```bash
apt update
apt install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev libpseudo locales vim
```

We've also installed vim to be able to edit any files within the container.

Yocto build system requires the system locale to be set to `en_US.UTF-8`

```bash
dpkg-reconfigure locales
```

Finally, we need to run the build as a different user because Yocto does not allow building as root

```bash
adduser yoctopi
su yoctopi
cd /home/yoctopi
```

Now, you should be good to follow the post referenced earlier to build a Linux system for the Raspberry Pi.

To return to the container any time in the future, run

```bash
docker start -ai yoctopi
su yoctopi
cd /home/yoctopi
```
