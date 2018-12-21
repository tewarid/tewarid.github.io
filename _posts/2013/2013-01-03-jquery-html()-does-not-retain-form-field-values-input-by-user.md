---
layout: default
title: jQuery html() does not retain form field values input by user
tags: jquery html javascript
comments: true
---
# jQuery html() does not retain form field values input by user

A call to JQuery `html()` function results in a document that does not retain form field values input by user. Here's a snippet of code that sets the right attributes of the input and select form fields so that `html()` renders form fields with values input by the user. It can be improved to do the same for textarea and so on.

```javascript
$('input').each(function(index) {
    $(this).attr('value', $(this).val());

    if ($(this).attr('type') == 'radio') {
        if ($(this).attr('checked') == 'checked') {
            $(this).attr('checked', 'checked');
         } else {
            $(this).removeAttr('checked');
         }
    }
});
$('select').each(function(index) {
    var selectedIndex = $(this).prop('selectedIndex');
    $(this).find('option').each(function (i) {
        if (i == selectedIndex) {
            $(this).attr('selected', 'true');
        } else if ($(this).attr('selected') != null) {
            // if is required because in IE 7 and 8
            // the removeAttr below causes unexpected
            // consequences
            $(this).removeAttr('selected');
        }
    });
});
```

Unfortunately, the above is not enough in IE 7 and 8, if you are using clone() before invoking html(). You'll need to copy the selectedIndex property of the original select element to the clone. This can be achieved as follows

```javascript
// jqueryObj is a clone of the document e.g. $('*').clone()
jqueryObj = jqueryObj.find('select');
$('select').each(function (srcIndex) {
    jqueryObj.eq(srcIndex).prop('selectedIndex', $(this).prop('selectedIndex'));
});
```
