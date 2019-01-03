---
layout: default
title: Object-oriented programming in JavaScript
tags: javascript object orientation
comments: true
---
# Object-oriented programming in JavaScript

After reading several articles all over the internet, I have arrived at the conclusion that for most cases a class should be created...

1. Using a constructor function

    ```javascript
    function Person(name) {
        this.name = name; // a public attribute
    }

    var p = new Person('zooey');
    console.log(p.name);
    ```

2. Using prototype object to define accessors (get/set) for attributes, as used in the following example to demonstrate data validation

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

    I start names of private attributes with an underscore.

3. Using the prototype object to add public methods shared by all objects

    ```javascript
    function Person(name) {
        this.name = name;
        this.age = undefined;
    }

    Person.prototype.isOlder = function(than) {
        return this.age > than.age;
    }

    var p1 = new Person('zooey');
    p1.age = 18;
    var p2 = new Person('emily');
    p2.age = 19;
    console.log(p1.isOlder(p2)); // false
    ```

4. Using private attributes and methods if the public method is implemented in the constructor function. Public and private methods implemented in the constructor function have the limitation of not being shared by objects. If you have a large number of objects, you'll be wasting useful memory.

    An example follows

    ```javascript
    function Person(name) {
        this.name = name;
        var _age; // private attribute
        this.age = undefined;

        // public method not shared by instances
        this.makeOlder = function(by) {
            _age = this.age;
            _makeOlder(by);
            this.age = _age;
        }

        // private method not shared by instances
        function _makeOlder(by) {
            _age += by;
        }
    }

    var p1 = new Person('zooey');
    p1.age = 18;
    p1.makeOlder(10);
    console.log(p1.age); // 28
    var p2 = new Person('emily');
    p2.age = 19;
    p2.makeOlder(10);
    console.log(p2.age); // 29
    ```

5. Using namespaces to avoid class name conflicts in large applications

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

If you are not familiar with [JSON](http://www.json.org/), you'll have a harder time following some of the examples above. It is fairly easy to learn though.
