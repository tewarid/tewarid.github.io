---
layout: default
title: Atmel AVR and AVR32
tags: topic
---

{% for post in site.posts %}

    {% if post.tags contains 'avr32' or post.tags contains 'avr' or post.tags contains 'atmel'  %}

[{{ post.title }}]({{ post.url }})

    {% endif %}

{% endfor %}
