---
layout: page
title: 归档文章
permalink: /collections/
show_footer: true
show_page_header: false
---

<div class="collections-page">
  <section class="archive-section" aria-labelledby="archive-categories-title">
    <div class="archive-section__header archive-section__header--compact">
      <h2 id="archive-categories-title" class="archive-section__title">类目</h2>
    </div>

    {% include category-cloud.html %}
  </section>

  <section class="archive-section" aria-labelledby="archive-tags-title">
    <div class="archive-section__header archive-section__header--compact">
      <h2 id="archive-tags-title" class="archive-section__title">标签</h2>
    </div>

    {% include tag-cloud.html %}
  </section>
</div>

<script src="{{ '/assets/js/collections.js' | relative_url }}"></script>
