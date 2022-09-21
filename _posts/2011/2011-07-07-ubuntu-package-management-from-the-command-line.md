---
layout: default
title: Ubuntu package management from the command line
tags: ubuntu apt dpkg
comments: true
---
# Ubuntu package management from the command line

These are the commands that I mostly use to manage packages from the CLI. See `man command` for more detailed help.

## apt search

`apt search text` to search for packages containing the specified text. Listed packages can be installed using `apt install`. To see details about a package use `apt show package`.

## apt edit-sources

`sudo apt edit-sources` to edit package source repositories.

After that, `sudo apt update` to update package cache from active repository sources.

## apt install

`sudo apt install package` to install a package.

`sudo apt upgrade package` to upgrade to latest version of a package.

## dpkg

`dpkg -l` to list all packages installed and their versions, pipe to `grep` to filter.

`sudo dpkg -i deb_package` to install from a package archive.

`dpkg -S file` to discover which package a file belongs to.

`sudo dpkg -r --force-depends` to forcefully remove a broken package e.g. `sudo dpkg -r --force-depends libssl1.0.0`.
