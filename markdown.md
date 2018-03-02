---
layout: default
title: Documentation as Code with Markdown
tags: topic
---

{% for post in site.posts %}

    {% if post.tags contains 'markdown' %}

[{{ post.title }}]({{ post.url }})

    {% endif %}

{% endfor %}
