---
layout: default
title: Install python and pip on Mac OS X
tags: python pip mac
comments: true
---
# Install python and pip on Mac OS X

Mac OS X ships with python. You can see its version using

```bash
python --version
```

You can see where it is installed using

```bash
which python
```

You may want the latest version of python, or install python packages using pip. The way I found to get the latest versions of python on Mac OS X is using macports. To install macports download the packaged version from their site and install. Further instructions can be found on their [install page](http://www.macports.org/install.php).

Once macports is installed, you can install latest version of python 2 thus

```bash
sudo port install python27
```

To learn all python versions available

```bash
port list python*
```

To find out all python packages available

```bash
port list py*
```

To install pip

```bash
sudo port install py27-pip
```

Now that pip is installed you can install python packages. To see installed packages

```bash
pip-2.7 list
```

To search for available packages e.g. all packages with Django in the text

```bash
pip-2.7 search Django
```

To install django

```bash
sudo pip-2.7 install Django==1.4.8
```

To see more details about a package such as where it is installed

```bash
pip-2.7 show Django
```

To use pip packages with the version of python that ships with OS X, export their path to PYTHONPATH and call python

```bash
export PYTHONPATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages
```
