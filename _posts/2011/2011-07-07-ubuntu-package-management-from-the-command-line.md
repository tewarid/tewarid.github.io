---
layout: default
title: Ubuntu package management from the command line
tags: ubuntu apt dpkg
comments: true
---
# Ubuntu package management from the command line

These are the commands that I mostly use to manage packages from the CLI. See `man command` for more detailed help.

## apt-cache

`apt-cache search text` to search for packages containing the specified text. Listed packages can be installed using `apt-get`. To see details about a package use `apt-cache showpkg packages`.

## apt-add-repository

`apt-add-repository url` to add a new repository source

`apt-add-repository -r url` to remove

## apt-get

`sudo apt-get install package_name` to install or upgrade a package

`sudo apt-get update` to update package cache from active respository sources, usually after a `apt-add-repository`

## dpkg

`dpkg -l` to list all packages installed and their versions. pipe to `grep` to filter.

`sudo dpkg -i deb_package` to install from a package archive

`dpkg -S file` to discover which package a file belongs to
`sudo dpkg -r --force-depends` to forcefully remove a broken package e.g. `sudo dpkg -r --force-depends libssl1.0.0`
