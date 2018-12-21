---
layout: default
title: Prepare HTML document for printing
tags: print web jquery javascript programming
comments: true
---
# Prepare HTML document for printing

Print style sheets should work with most modern browsers, unless they don't. I've had problems with IE 7 and 8 in particular. The following code snippet demonstrates how I massage my document before writing it out to an empty document or iframe.

```javascript
// jqueryObj is a set of elements returned by a selector e.g. $('*')

// remove undesired elements
jqueryObj.find('script').remove().end();
jqueryObj.find('img').remove().end();
jqueryObj.find('button').remove().end();

// remove event handlers
jqueryObj.find('[onclick]').removeAttr('onclick').end();
jqueryObj.find('[onkeypress]').removeAttr('onkeypress').end();
jqueryObj.find('[onkeyup]').removeAttr('onkeyup').end();
jqueryObj.find('[onblur]').removeAttr('onblur').end();
jqueryObj.find('[onfocus]').removeAttr('onfocus').end();
jqueryObj.find('[onchange]').removeAttr('onchange').end();

// avoid scrollbars
jqueryObj.find('div').css('width', '100%').end();
jqueryObj.find('div').css('height', 'auto').end();
jqueryObj.find('div').css('overflow', 'hidden').end();
jqueryObj.find('ul').css('height', 'auto').end();
jqueryObj.find('ul').css('overflow', 'hidden').end();

// disable form input elements
jqueryObj.find('input').attr('readonly', 'readonly').end();
jqueryObj.find('input[type="radio"]').attr('disabled', 'disabled').end();
jqueryObj.find('select').attr('disabled', 'disabled').end();
```

Additionally, you can remove undesired CSS classes thus:

```javascript
jqueryObj.find('.class1').removeClass('class1').end();
```

There may be a better alternative to render form input elements unchangeable. The manner implemented here causes them to appear grayed out. Tweaking their style with CSS so that they don't appear grayed out may help.

Another option is to use an absolutely positioned transparent div on top of everything else

```html
<div style="position:absolute;top:0;left:0;height:100%;width:100%;z-index:999;background-color:white;opacity:0;filter:alpha(opacity=0);"></div>
```
