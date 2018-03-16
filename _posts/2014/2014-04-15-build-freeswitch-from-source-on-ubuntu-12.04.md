---
layout: default
title: Build FreeSWITCH from source on Ubuntu 12.04
tags: freeswitch build ubuntu
comments: true
---

FreeSWITCH has a fairly detailed Wiki page on [download and installation](https://freeswitch.org/confluence/display/FREESWITCH/Ubuntu+Quick+Start). This post cuts to the chaff.

Execute the following commands from terminal in the order specified. You should be fine doing it in your home folder.

```bash
sudo apt-get install git-core build-essential autoconf automake libtool libncurses5 libncurses5-dev make libjpeg-dev pkg-config unixodbc unixodbc-dev zlib1g-dev libcurl4-openssl-dev libexpat1-dev libssl-dev libtiff4-dev libx11-dev unixodbc-dev zlib1g-dev libzrtpcpp-dev libasound2-dev libogg-dev libvorbis-dev libperl-dev libgdbm-dev libdb-dev python-dev uuid-dev bison autoconf g++ libncurses-dev speex libspeexdsp-dev libedit-dev libpcre3-dev

git clone https://freeswitch.org/stash/scm/fs/freeswitch.git

cd freeswitch

./bootstrap.sh

./configure

make

sudo make install cd-sounds-install cd-moh-install
```

Configuration files are located under `/usr/local/freeswitch/conf`, if you want to edit any.

Execute FreeSWITCH as superuser thus

```bash
sudo /usr/local/freeswitch/bin/freeswitch -nc
```

Remove `-nc` option to run in console mode.

To stop FreeSWITCH

```bash
sudo /usr/local/freeswitch/bin/freeswitch -stop
```

If you get "`libspandsp.a: No such file or directory`" [error](https://jira.freeswitch.org/browse/FS-6405) when executing `make` after a `make clean`, execute the following commands and resume `make`.

```bash
cd libs/spandsp
make clean
make
cd ../..
```

To ensure a clean build, use `git clean -f -x` instead of `make clean`.

_Kudos: Henrique Borges, Vitória Vasconcelos_
