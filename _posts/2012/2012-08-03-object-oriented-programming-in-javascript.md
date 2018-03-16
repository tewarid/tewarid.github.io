---
layout: default
title: Object-oriented programming in JavaScript
tags: javascript object orientation
comments: true
---

After reading several articles all over the internet, I have arrived at the conclusion that for most cases a class should be created...

1. Using a constructor function.

    This example demonstrates how

    ```javascript
    function Person(name) {
    this.name = name; // a public attribute
    }

    var p = new Person('zooey');
    console.log(p.name);
    ```

2. Using prototype object to define accessors (get/set) for attributes. This can for instance be useful for validation.

    The following example demonstrates that

    ```javascript
    function Person(name) {
    this.name = name;
    this._age = undefined;
    }

    Person.prototype = {
    get age() {
        return this._age;
    },
    set age(val) {
        if (val < 18)
        throw('must be 18');
        this._age = val;
    }
    }

    var p = new Person('zooey');
    try {
    p.age = 17;
    } catch(e) {
    console.log(e);
    }
    console.log(p.age); // undefined
    p.age = 18;
    console.log(p.age); // 18
    ```

    I use attribute names that start with an underscore as a convention to indicate that they are private.

3. Using the prototype object to add public methods. This has the advantage that the method implementation is shared by all objects.

    This is how you create and use public methods

    ```javascript
    function Person(name) {
    this.name = name;
    this.age = undefined;
    }

    Person.prototype.isOlder = function(p) {
    return this.age > p.age;
    }

    var p1 = new Person('zooey');
    p1.age = 18;
    var p2 = new Person('emily');
    p2.age = 19;
    console.log(p1.isOlder(p2)); // false
```

4. Using private attributes and methods as sparingly as possible. Since they cannot be accessed by public methods as created in step 3, their usefulness may be limited. They can be useful if the public method is implemented in the constructor function. Both public and private methods implemented in the constructor function have the limitation of not being shared by objects. So if you have a large number of objects, you'll be wasting useful memory.

    An example follows

    ```javascript
    function Person(name) {
    this.name = name;
    var _previousage; // private attribute
    this.age = undefined;

    // public method - not shared by instances
    this.makeOlder = function(by) {
        _previousage = this.age;
        makeOlder(by);
    }

    // private method - not shared by instances
    function makeOlder(by) {
        this.age += by;
    }
    }

    var p = new Person('zooey');
    p.age = 18;
    p.makeOlder(10);
    console.log(p.age);
    ```

5. Using namespaces to avoid class name conflicts in large applications.

    This example illustrates how

    ```javascript
    var company = company || {
    model: {}
    }

    company.model.Person = function (name) {
    this.name = name;
    }

    var p = new company.model.Person('zooey');
    console.log(p.name);
    ```

If you are not familiar with [JSON](http://www.json.org/), you'll have a hard time following some of the examples above. It is fairly easy to learn though.
