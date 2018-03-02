---
layout: default
title: Documentation using Markdown and Pandoc
tags: topic
---

{% for post in site.posts %}

    {% if post.tags contains 'markdown' %}

[{{ post.title }}]({{ post.url }})

    {% endif %}

{% endfor %}
