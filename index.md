---
layout: default
title: hello, world!
tags: update
---

I am a software engineer by profession, a maker by heart, and have a lovely family at Recife, Brazil. You can find a [résumé](https://github.com/tewarid/resume) and some of my work at GitHub.

Navigate posts chronologically, by [topic]({% link topics/topic.md %}), or use [Google Search](https://cse.google.com/cse/publicurl?cx=007972243254995935457:as_8bpaffdc).

{% for post in site.posts  %}
    {% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

    {% if forloop.first %}
### {{this_year}}
    {% endif %}

    {% if post.languages == nil or post.languages contains "en" %}
[{{ post.title }}]({{ post.url }})
    {% endif %}

    {% if forloop.last %}
    {% else %}
        {% if this_year != next_year %}
### {{next_year}}
        {% endif %}
    {% endif %}
{% endfor %}
