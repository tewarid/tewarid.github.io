---
layout: default
title: Access control
tags: access control design
comments: true
---
# Access control

In this post I document a simple domain model that I have used to implement access control in my projects, the first time being sometime in 1998.

The model described here assumes that authentication is already done, you get some kind of user ID, and have to make the access control decision. It is different from resource oriented access control mechanisms such as access to files, and database structures.

## The entities or classes

The primary entities in the domain are

* User

    Represents a user. Each user is identified by a unique ID.

* Action

    Represents an action in the system e.g. Log into the system, View users, and so on. Each Action is identified by a unique ID. Nouns Operation or Function may be used instead of Action if they fit your use case better.

* Profile

    Represents a set of users e.g. System administrators. Each profile is identified by a unique ID. Group or Role may be used instead of Profile if they fit your use case better.

## The relationships

The entities or classes are related in the following manner

* Profile-Action

    The actions each profile can perform (or has access to).

* User-Profile

    The profiles each user is associated with.

## Making the access control decision

The access control decision can be implemented at any point in the code where an Action is performed. You can get a list of all Actions the User can perform by traversing from User-Profile to Profile-Action. You allow the Action to proceed if its ID is found to be associated with the User, or else throw an exception.

## Authentication

Although not the focus of this post, password based authentication can be handled by adding a password hash to the User entity. The authentication decision can be implemented in a [front controller](http://www.martinfowler.com/eaaCatalog/frontController.html) and the user ID stored in the session context for access control decisions downstream.
