---
layout: default
title: Using hints inside text fields instead of labels
tags: jquery hint text input html javascript programming
comments: true
---
# Using hints inside text fields instead of labels

The following code example demonstrates replacing labels with hints that appear as temporary values within text fields; akin to placeholder attribute in HTML5.

A custom attribute called data-hint-value contains the hint value to which a text field gets initialized. That value represents what typically would be the value of a label associated with the text field. It is cleared when the text field receives focus, and filled with hint value if text field is empty on blur.

{% gist b404e71c8f4d9174b679f3fa380f1417 %}

setAllTextToHint is a helper function that sets all text fields to their hint values. isTextValueValid may be used to check whether a text field contains some value, and alerts the user when it does not. Tweak these as you see fit.
