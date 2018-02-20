---
layout: default
title: Useful Docker commands
tags: docker linux
---

# Useful Docker commands

Interactively run command in a new container based on a Docker image

```bash
docker run -t -i -v `pwd`:/workdir -w /workdir 90e5ddae9277 /bin/bash
```

You can specify an image id, name, or name:tag. Image is downloaded from a [configured registry](https://docs.docker.com/registry/configuration/), if needed. The current directory on the host is mapped to `/workdir` in the container. `/bin/bash` is started in that directory.

List running containers

```bash
docker ps
```

List all containers, and their sizes

```bash
docker ps -a -s
```

Start a stopped container, with terminal access

```bash
docker start -a -i 2edf9d536e3c
```

Remove a container

```bash
docker rm 2edf9d536e3c
```

Build an image using Dockerfile in the current folder

```bash
docker build .
```

Save Docker image

```bash
docker save -o myimage.tar 90e5ddae9277
```

Load Docker image from an input archive

```bash
docker load -i myimage.tar
```

List Docker images

```bash
docker image ls
```

Remove a Docker image

```bash
docker image rm 90e5ddae9277
```

See image history in human readable format - useful for identifying all the layers in an image

```bash
docker history -H 90e5ddae9277
```