---
layout: default
title: Jupyter Notebook with Docker and JupyterHub
tags: jupyter jupyterhub notebook docker
comments: true
---
# Jupyter Notebook with Docker and JupyterHub

[JupyterHub](https://github.com/jupyterhub/jupyterhub) enables you to quickly setup Jupyter Notebook for multiple users. In this post, I use Docker to setup Notebook for multiple users. You'll need to install Docker for your platform to follow along.

To download and create a new JupyterHub container with Docker

```bash
docker run -p 8000:8000 --name jupyterhub jupyterhub/jupyterhub jupyterhub
```

If you want to restart the container later

```bash
docker start -ai jupyterhub
```

You should now be able to access JupyterHub via http://localhost:8000. `localhost` may be changed to an IP address, if you need to access the page from a different machine. You'll need a user to be able to login.

Create a command shell into the running container

```bash
docker exec -it jupyterhub bash
```

To setup a user

```bash
adduser username
```

Change `username` to a user's login. You will be prompted for a password and other information. Complete all the steps. You should now be able to login using the username and password you setup.

The container image does not come with Jupyter Notebook, so we need to install it

```bash
conda install notebook
```

You should now be able to create and use Notebooks. To install any additional Python packages required by your Notebooks

```bash
pip install pandas matplotlib
```
