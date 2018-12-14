{% assign write_year = false %}
{% for post in site.posts  %}
    {% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

    {% if forloop.first %}
        {% assign write_year = true %}
    {% endif %}

    {% assign lang = post.languages %}
    {% if lang == nil %}
        {% assign lang = "en" | split: "," %}
    {% endif %}

    {% if lang contains include.lang %}
        {% if write_year %}
### {{this_year}}
            {% assign write_year = false %}
        {% endif %}
[{{ post.title }}]({{ post.url }})
    {% endif %}

    {% if forloop.last %}
    {% else %}
        {% if this_year != next_year %}
            {% assign write_year = true %}
        {% endif %}
    {% endif %}
{% endfor %}
