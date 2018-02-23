---
layout: default
title: Access control
tags: access control design
---

In this post I document a simple domain model that I have used to implement access control in my projects, the first time being sometime around 1998. I have since seen similar approaches to access control elsewhere, so you may already be familiar with it.

The approach mentioned here assumes that authentication is already done, you get some kind of user ID, and have to make the access control decision. It is different from resource oriented access control mechanisms, such as access to files, database structures and so on.

### The entities or classes

The primary entities in the domain are

* User

    Represents a user. Each user is identified by a unique ID.

* Action

    Represents an action in the system e.g. Log into the system, View users, and so on. I have also called this Operation or Function in the past. Each Action is identified by a unique ID.

* Profile

    Represents a set of users e.g. System administrators. Each profile is identified by a unique ID. Profile may also be called Group, if you find that more convenient.

### The relationships

The entities or classes are related in the following manner

* Profile-Action

    The actions each profile can perform (or has access to).

* User-Profile

    The profiles each user is associated with.

### Making the access control decision

The decision can be implemented at the point in the code where the action is performed. You need to get a list of all actions the user can perform by traversing from User-Profile to Profile-Action. If the ID of the Action is found to be associated with the User, she is granted access.

### Authentication

Although not the focus of the post, password based authentication can be handled by adding a password hash to the User entity. The authentication decision can be implemented in a [front controller](http://www.martinfowler.com/eaaCatalog/frontController.html) and the user ID stored in the session for access control decisions downstream.
