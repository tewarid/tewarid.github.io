---
layout: default
title: hello, world!
tags: update
---

I am a software engineer by profession, a maker by heart, and have a lovely family at Recife, Brazil. You can find a [résumé](https://github.com/tewarid/resume) and some of my work at GitHub.

### Topics

[Documentation as Code with Markdown]({% link markdown.md %})

[OpenSSL]({% link openssl.md %})

[Wireshark and Lua Dissectors]({% link lua-dissectors.md %})

{% for post in site.posts  %}
    {% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

    {% if forloop.first %}
### {{this_year}}
    {% endif %}

[{{ post.title }}]({{ post.url }})

    {% if forloop.last %}
    {% else %}
        {% if this_year != next_year %}
### {{next_year}}
        {% endif %}
    {% endif %}
{% endfor %}
