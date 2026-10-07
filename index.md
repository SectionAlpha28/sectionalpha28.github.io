---
title: Welcome to Section A
feature_text: |
  ## HBS Class of 2028 · Section A
  Welcome to the home on the web for Section A
excerpt: "The home on the web for Section A of the Harvard Business School MBA Class of 2028."
---

Welcome to the website of **Section A**, Harvard Business School MBA Class of 2028. This is where we share section news, upcoming events and useful resources with classmates, partners and friends of the section.

{% assign page_about_url = "/about/" | relative_url %}{% assign page_events_url = "/events/" | relative_url %}{% assign page_blog_url = "/blog/" | relative_url %}
{% include button.html text="About the section" link=page_about_url %} {% include button.html text="Upcoming events" link=page_events_url %} {% include button.html text="Latest news" link=page_blog_url %}

## Latest news

{% for post in site.posts limit:3 %}
- [{{ post.title }}]({{ post.url | relative_url }}) <small>{{ post.date | date: "%B %-d, %Y" }}</small>
{% endfor %}

## Get involved

Have a photo, a recap or an event you'd like to share? See the [contact page]({{ "/contact/" | relative_url }}) for how to get it on the site.

<small>This is an unofficial, student-run website. It is not affiliated with or endorsed by Harvard Business School or Harvard University.</small>
