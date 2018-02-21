---
layout: default
title: Upgrading to a newer version of Atmel Software Framework
tags:
---

This post is a brief description of the procedure that I follow to upgrade to a newer version of the Atmel Software Framework (ASF).

I have now switched to newer ASF versions so often that it has become second nature. I create a new project from scratch and add the required drivers and services using the ASF Wizard, and copy my own code over to the new project. That is usually all that is required to perform the upgrade. Some project specific settings sometimes need to be copied over manually such as compiler settings and linker script modifications.

If I see any specific API changes, I start from an Example Project supplied with Atmel Studio, study the API using an Evaluation Kit board (EVK), and then change my code appropriately.
