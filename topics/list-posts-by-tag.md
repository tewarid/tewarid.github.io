{% assign tags = page.tags | split: " " %}

{% for post in site.posts %}

    {% for tag in tags %}

        {% if post.tags contains tag %}

[{{ post.title }}]({{ post.url }})

            {% break %}
        {% endif %}

    {% endfor %}

{% endfor %}
