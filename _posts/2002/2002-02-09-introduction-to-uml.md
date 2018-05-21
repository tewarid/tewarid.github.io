---
layout: default
title: Introduction to UML
tags: uml software design
comments: true
---

This is a short introduction to UML diagrams, based on OMG's [Unified Modeling Language Specification](https://www.omg.org/spec/UML/1.4/About-UML/), and the online help in Rational Rose Enterprise Edition.

### Class diagrams

A Class diagram depicts classes and the relationships between them.

#### Class

A class is the prototype of an object, or similar objects, in an object oriented system. A Class is composed of private or public data members and methods that act on them.

#### Generalize relationship

<div class="mermaid" style="height:300px;">
classDiagram
    Primate <|-- Gorilla : is a
    Primate : int id
    Primate : brainSize()
</div>

A generalize relationship between classes shows that the subclass shares the structure or behavior defined in one or more super-classes.

#### Realize relationship

A realize relationship between classes and interfaces and between components and interfaces shows that the class realizes the methods offered by the interface.

#### Association relationship

An association provides a pathway for communication. The communication can be between two classes or between a class and an interface. Associations are the most general of all relationships and consequentially the most semantically weak. If two objects are usually considered independently, the relationship is an association.

##### Uni-directional association

<div class="mermaid" style="height:300px;">
classDiagram
    Producer --> Actor
</div>

The uni-directional association is drawn on a diagram with a single arrow at one end of the association. The end with the arrow indicates who or what is receiving the communication.

##### Bi-directional association

<div class="mermaid" style="height:300px;">
classDiagram
    Teacher <--> Student
</div>

The flow of communication is both-ways in this association.

#### Aggregate relationship

<div class="mermaid" style="height:300px;">
classDiagram
    Form *-- TextField
    Form *-- Label
</div>

Use the aggregate relationship to show a whole and part relationship between two classes. Use the aggregate relationship to show that the aggregate object is physically constructed from other objects or that it logically contains another object. The aggregate object has ownership of its parts.

#### Dependency relationship

Draw a dependency relationship between two classes, or between a class and an interface, to show that the client class depends on the supplier class/interface to provide certain services.

#### Three-Tiered diagram

A three-tiered diagram is a Class Diagram that is divided into three tiers. Each tier corresponds to a logical package, which in turn corresponds to a service layer: User Services, Business Services, and Data Services.

### Use case diagrams

Use-case diagrams graphically depict system behavior (use cases). These diagrams present a high level view of how the system is used as viewed from an outsider’s (actor’s) perspective. A use-case diagram may depict all or some of the use cases of a system.

#### Actors

Actors represent people or other systems that use the system. They help to delimit the system and give a clearer picture of what the system should do. It is important to note that an actor interacts with, but has no control over the use cases.

An actor is someone or something that:

- Interacts with or uses the system

- Provides input to and receives information from the system

- Is external to the system and has no control over the use cases

Examining the following can be used to discover actors:

- Who directly uses the system

- Who is responsible for maintaining the system

- External hardware used by the system

- Other systems that need to interact with the system

#### Use case

A use case can be described as a specific way of using the system from a user’s perspective. A more detailed description might characterize a use case as:

- A pattern of behavior the system exhibits

- A sequence of related transactions performed by an actor and the system

- Delivering something of value to the actor

Use cases provide a means to:

- Capture system requirements

- Communicate with the end users and domain experts

- Test the system

#### Association relationship

The Association Relationship is the same as used in Class Diagrams. It is only used to demonstrate the participation of an actor in a use case.

#### Include relationship

An include relationship defines that a use case includes the behavior defined in another use case. The behavior in the addition UseCase is inserted into the behavior of the base UseCase. The base UseCase must only depend on the result of performing the behavior defined in the addition UseCase, but not on the structure, i.e. on the existence of specific attributes and operations, of the addition UseCase.

#### Extend relationship

An *extend* relationship defines that instances of a use case may be extended with some additional behavior defined in an extending use case. Extend relationship is a directed relationship implying that a UseCaseInstance of the base UseCase may be extended with the structure and behavior defined in the extending UseCase. The relationship consists of a condition, which must be fulfilled if the extension is to take place, and a sequence of references to extension points in the base UseCase where the additional behavior fragments are to be inserted.

### Sequence diagrams

<div class="mermaid">
sequenceDiagram
    participant caller
    participant exchange
    participant receiver
    caller->>exchange: lift receiver
    exchange->>caller: dial tone
    caller->>exchange: dial digit
    Note right of caller: ...
    exchange->>receiver: phone rings
    exchange->>caller: ringing tone
    receiver->>exchange: answer phone
    Note left of receiver: < 1 sec
    exchange->>receiver: stop ringing
    exchange->>caller: stop tone
</div>

A sequence diagram is a graphical view of a scenario that shows object interaction in a time-based sequence - what happens first, what happens next. Sequence diagrams establish the roles of objects and help provide essential information to determine class responsibilities and interfaces. This type of diagram is best used during early analysis phases in design because they are simple and easy to comprehend. Sequence diagrams are normally associated with use cases.

Sequence diagrams are closely related to collaboration diagrams and both are alternate representations of an interaction. There are two main differences between sequence and collaboration diagrams: sequence diagrams show time-based object interaction while collaboration diagrams show how objects associate with each other.

A sequence diagram has two dimensions: typically, vertical placement represents time and horizontal placement represents different objects.

### Collaboration diagrams

Collaboration diagrams and sequence diagrams are alternate representations of an interaction. A collaboration diagram shows the sequence of messages that implement a method or a transaction.

Collaboration diagrams show objects, their links, and their messages. They can also contain simple class instances and class utility instances. Each collaboration diagram provides a view of the interactions or structural relationships that occur between objects and object-like entities in the current model.

The following are components of a collaboration diagram:

- Object

    An object has state, behavior, and identity.

- Link

    Link is an instance of an association just as an object is an instance of a class.

### Activity diagrams

Activity diagrams provide a way to model the workflow of a business process or a way to model a class method. These diagrams are very similar to a flowchart because you can model a workflow from activity to activity or from activity to state.

Activity diagrams can model many different types of workflows. For example, a company could use activity diagrams to model the flow for an approval of orders or model the paper trail of invoices. An accounting firm could use activity diagrams to model any number of financial transactions. A software company could use activity diagrams to model part of a software development process.

An activity diagram is considered a special case of a state machine in which most of the states are activities and most of the transitions are implicitly triggered by completion of the actions in the source activities. The main difference between activity diagrams and statecharts is activity diagrams are activity centric, while statecharts are state centric. An activity diagram is typically used for modeling the sequence of activities in a process, whereas a statechart is better suited to model the discrete stages of an object’s lifetime.

### Statechart diagrams

Statechart diagrams are like activity diagrams but instead of transition from activity to activity they show transitions of states of objects. A statechart is better suited to model the discrete stages of an object’s lifetime.
