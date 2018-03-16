---
layout: default
title: Using custom attributes
tags: html custom attribute jquery javascript web programming
comments: true
---

In this post I build my own reusable validation mechanism to demonstrate the use of custom attributes. There exist [validation plugin](https://github.com/jzaefferer/jquery-validation)s for jQuery already, you may be better off using them. If other validation mechanisms do not serve your needs for whatever reason, you can use the code posted here as a guidepost.

The mechanism demonstrated here can use just about any HTML tag with inline text as a field. Data entry does require the use of the input and select elements. I also build a utility function than can transfer data from fields into an object. Similarly, another utility function can transfer object properties to fields, in a specified output format. I leverage the jQuery [Globalize](https://github.com/jquery/globalize) library contributed by Microsoft for formatting culture specific values. To keep things simple mapping is done for value properties only. Mapping of objects and collections is the logical next step.

### A test page

The code below lists the HTML file used for testing. It should run quite all right in all major browsers. I did have an issue with Internet Explorer embedded in a .NET application using the WebBrowser control. A jQuery selector like `$(span[for="foo"])` would return no elements, even though there was a matching span with the attribute _for_ in the markup. Changing the attribute name to input, or to data-input as I did, was the only viable alternative. Go figure.

```html
<html>
<head>
    <title>custom attributes</title>
</head>
<body>

<div id="input">
    Name
    <input data-property="name" data-check="required" type="text">
    <span style="color: red" data-input="name">required</span>
    <br/>
    Age
    <input data-property="age" data-type="integer" data-check="required" type="text">
    <span style="color: red" data-input="age">required</span>
</div>

<button>OK</button>

<div id="output" style="display: none">
    Hello <span data-property="name">xxx</span>!<br/>
    You are <span data-property="age" data-format="n0">xxx</span> years old.
</div>

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="globalize.js"></script>
<script src="binding.js"></script>
<script src="input.js"></script>

<script>
    // the Person constructor
    function Person(name) {
        this.name = name;
        this.age = undefined;
    }

    $(document).ready(function() {
        $('button').click(function(event) {
            if (!validate('div#input', 'value')) return;
            var p = new Person();
            setProperties(p, 'div#input', 'value');
            getProperties(p, 'div#output');
            $('#output').show();
        });
    });
</script>
</body>
</html>
```

### The validation mechanism

The following code shows the listing of input.js.

```javascript
/* depends on jQuery */

$(document).ready(function() {
    // hide error message display
    $('span[data-input]').hide();

    $('input[data-property]').keypress(function(event) {
        var property = $(this).attr('data-property');
        $('span[data-input="'+ property + '"]').hide();
    });

    // prevent key press
    $('input[data-type="integer"]').keypress(function(event) {
        var charCode = event.keyCode ? event.keyCode : event.charCode;
        var charStr = String.fromCharCode(charCode);
        var integerChecker = /\d/;
        if (!integerChecker.test(charStr)) {
            event.preventDefault();
        }
    });
});

function isOfType(value, datatype) {
    var retVal = true;
    if (datatype == 'integer' || datatype == 'decimal') {
        retVal = !isNaN(value);
    }
    return retVal;
}

function validate(selector, attribute) {
    var noerror = true;

    $(selector + ' [data-property]').each(function(index) {
        var property = $(this).attr('data-property');
        var check = $(this).attr('data-check');
        var datatype = $(this).attr('data-type');
        var value;

        if (attribute) {
            value = $(this).prop('value');
        } else {
            value = $(this).text();
        }

        var errorlabel = $('span[data-input="' + property + '"]');

        if (check == 'required' && value === '') {
            errorlabel.text('required');
            errorlabel.show();
            noerror = false;
        } else if(check == 'required' && !isOfType(value, datatype)) {
            errorlabel.text('specify ' + datatype + ' value');
            errorlabel.show();
            noerror = false;
        }
    });
    return noerror;
}
```

### Data binding

Finally, here's the code for binding.js. You'll get better results from well regarded libraries such as [AngularJS](https://angularjs.org/) and [Knockout](http://knockoutjs.com/), they leverage custom attributes and are well documented.

```javascript
/* depends on jQuery and globalize.js */

function typedValue(value, datatype) {
    if (datatype == 'integer') {
        return parseInt(value);
    } else if (datatype == 'decimal') {
        return parseFloat(value);
    }
    else {
        return value;
    }
}

function formatValue(value, format) {
    if (format) {
        return Globalize.format(value, format);
    } else {
        return value;
    }
}

function setProperties(object, selector, attribute) {
    $(selector + ' [data-property]').each(function(index) {
        var property = $(this).attr('data-property');
        var datatype = $(this).attr('data-type');

        if (attribute == undefined) {
            object[property] = typedValue($(this).text(), datatype);
        } else {
            object[property] = typedValue($(this).prop(attribute), datatype);
        }
    });
}

function getProperties(object, selector, attribute) {
    $(selector + ' [data-property]').each(function(index) {
        var property = $(this).attr('data-property');
        var format = $(this).attr('data-format');

        if (attribute) {
            $(this).prop(attribute, formatValue(object[property], format));
        } else {
            $(this).text(formatValue(object[property], format));
        }
    });
}
```
