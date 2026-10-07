---
title: Section A
hide_title: true
feature_text: |
  ## Section A
  HBS Class of 2028 · One room, many stories
excerpt: "Section A of the Harvard Business School MBA Class of 2028: the people, the stories and the year we share."
---

<p class="lede">For one year, the same group of people sits in the same classroom, every day, arguing about the same cases. By the end, they're something closer to family. This is Section A.</p>

<p class="eyebrow">Meet the section</p>

## The people

Each seat in the room comes with a different story. Get to know the classmates behind the cold calls.

{% include member-grid.html limit=4 %}

{% assign members_url = "/members/" | relative_url %}
{% include button.html text="Meet everyone" link=members_url %}

<p class="eyebrow">Life in Section A</p>

## Latest stories

<ul class="story-list">
{% for post in site.posts limit:3 %}
  <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a><span>{{ post.date | date: "%B %-d, %Y" }}</span></li>
{% endfor %}
</ul>

<p class="eyebrow">What we're about</p>

<div class="pillars">
  <div>
    <h3>In the room</h3>
    <p>Placeholder: what makes Section A's classroom discussions memorable.</p>
  </div>
  <div>
    <h3>Beyond the case</h3>
    <p>Placeholder: the dinners, trips and traditions that happen outside class.</p>
  </div>
  <div>
    <h3>For life</h3>
    <p>Placeholder: what the section hopes to carry forward after HBS.</p>
  </div>
</div>

<p class="note">This is an unofficial, student-run website. It is not affiliated with or endorsed by Harvard Business School or Harvard University.</p>
