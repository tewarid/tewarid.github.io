---
layout: default
title: GRASP SOLID for effective object-oriented programming
tags: object programming grasp solid
comments: true
---

Objects are responsible for their state and behavior. Assigning responsibilities to objects effectively makes maintenance of a program less cumbersome.

This post summarizes the GRASP patterns and SOLID principles. They may be thought as the principles and patterns underlying the design patterns described in _Design Patterns: Elements of Reusable Object-Oriented Software_.

### GRASP Patterns

General Responsibility Assignment Principles or GRASP patterns were popularized by Craig Larman in his book _Applying UML and Patterns_ (2001). They help with identifying objects required by a program, and their responsibilities.

_Creator_

Assign responsibility of creation to object that contains, or has the information required to create, a given object.

_Controller_

Assign responsibility to object representing a module’s facade, or a handler of a use case. Beware of a fat controller.

_High Cohesion (HC)_

Assign responsibility to object with closely related state and behavior. Don't Repeat Yourself (DRY) rule helps maintain HC.

_Indirection_

Assign responsibility to an intermediary object so that coupling is low.

_Information Expert (IE)_

Assign responsibility to object that has related information.

_Low Coupling (LC)_

Creation, inheritance, type reference, and message passing, all result in coupling. Assign responsibility such that coupling is low between objects that are not closely related in state and behavior.

_Polymorphism_

Assign behavior to subclass when related behavior varies by type. Prefer aggregation and composition to inheritance.

_Protected Variations (PV)_

Assign responsibility to new object that provides a stable interface around known instabilities.

_Pure Fabrication (PF)_

Assign responsibility to a new object not derived from the domain to ensure LC and HC.

### SOLID Principles

SOLID are more generalized principles popularized by Robert Martin aka Uncle Bob in his book _Agile Software Development: Principles, Patterns, and Practices_ (2002).

_Single-Responsibility Principle (SRP)_

A class or module does one thing well. See _HC_.

_Open-Closed Principle (OCP)_

A class, module, or function, should be closed for modification but open for extension.

_Liskov Substitution Principle (LSP)_

Subclasses must be substitutable by their base (super) classes.

_Interface Segregation Principle (ISP)_

Avoid situation where clients depend on a fat interface. Changes to fat interface due to any client will affect all the other clients.

_Dependency Inversion Principle (DIP)_

Prevent modules in higher (more abstract) layers of an architecture from being impacted by changes in modules in lower layers. Abstractions should not depend on concrete implementations.