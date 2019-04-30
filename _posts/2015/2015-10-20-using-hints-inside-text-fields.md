---
layout: default
title: Using hints inside text fields
tags: jquery hint text input html javascript programming
comments: true
---
# Using hints inside text fields

The following code example demonstrates placing temporary values within text fields&mdash;akin to placeholder attribute in HTML5.

A custom attribute called data-hint-value contains the hint value to which a text field gets initialized. That value represents what typically would be the value of a label associated with the text field. It is cleared when the text field receives focus, and filled with hint value if text field is empty on blur.

```html
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>
    <link rel="shortcut icon" href="favicon.ico">
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
</head>
<body>
    <div>Name</div>
    <input id="name" type="text" data-hint-value="FirstName LastName" />
    <script type="text/javascript">
        $(document).ready(function() {
            setAllTextToHint();
        });

        function setAllTextToHint() {
            $(":text").each(function (index) {
                hint = $(this).attr("data-hint-value");
                if (hint) $(this).val(hint);
            });
        }

        function isTextValueValid(id) {
            var ret = false;
            $(":text").each(function (index) {
                thisId = $(this).attr("id");
                if (thisId == id) {
                    hint = $(this).attr("data-hint-value");
                    value = $(this).val();
                    if (value == hint || value == "") {
                        $(this).val(hint);
                        $(this).focus();
                        return;
                    } else {
                        ret = true;
                        return;
                    }
                }
            });
            return ret;
        }

        $(":text").focus(function () {
            hint = $(this).attr("data-hint-value");
            if ($(this).val() == hint)
                $(this).val("");
        });

        $(":text").blur(function () {
            hint = $(this).attr("data-hint-value");
            if ($(this).val() == "") {
                $(this).val(hint);
            }
        });
    </script>
  </body>
</html>
```

setAllTextToHint is a helper function that sets all text fields to their hint values. isTextValueValid may be used to check whether any text input contains the hint value.
