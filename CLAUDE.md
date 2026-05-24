# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
script/serve.sh        # Local dev server at http://127.0.0.1:2000 with drafts + livereload
script/clean.sh        # Clean the _site output directory
script/deploy-push-gh-pages.sh  # Build and force-push to gh-pages branch
script/build-raphael.sh    # Build the raphael-publish submodule, copy dist into tools/raphael-publish
script/update-submodules.sh  # Bump submodule pointer(s) to latest on tracked branch, then stage
```

Direct equivalents if needed:
```bash
bundle exec jekyll build --drafts   # Build only
bundle exec jekyll serve --drafts --livereload --port 2000
```

## Branch Workflow

- `master` — production branch, deployed to GitHub Pages
- `post` — working branch for drafts and in-progress posts; merge to `master` to publish

Drafts in `_drafts/` are included when serving/building with `--drafts`. Posts in `_posts/` are published by date (future-dated posts are excluded from normal builds but included with `--future`).

## Architecture

This is a custom Jekyll blog with a hand-built theme called **minutia** (no third-party theme gem). The theme lives entirely in this repo.

### Sass Module Structure

The Sass entry point is `assets/css/main.scss` which uses Dart Sass `@use`/`@forward`:

```
assets/css/main.scss
  @use 'minutia'       → _sass/minutia.scss (forwards sub-modules)
  @use 'svg-icons'     → _sass/_svg-icons.scss (static, no variables)

_sass/minutia.scss
  @forward 'minutia/variables'          → all variables + mixins (source of truth)
  @forward 'minutia/base'               → reset, typography, inputs, tables
  @forward 'minutia/layout'             → header, footer, post layout, tool pages
  @forward 'minutia/syntax-highlighting' → code blocks (uses nimbus-pygments theme)

_sass/minutia/_variables.scss           → uses sass:color; all $variables and mixins
_sass/minutia/nimbus-pygments/          → self-contained dark syntax highlighting theme
```

Each partial (`_base.scss`, `_layout.scss`, `_syntax-highlighting.scss`) starts with `@use 'variables' as *` to get variables without namespace prefix. Do not use `@import` — it is deprecated and removed in Dart Sass 3.

### Layouts

- `default` — base layout with header/footer, wraps all others
- `post` — for blog posts; supports front matter: `toc: true`, `mathjax: true`
- `page` — for static pages (`_pages/`)
- `tool` — for tool pages with a sidebar (`_data/tool-sidebar.yml`)
- `home` — homepage post listing
- `compress` — HTML minification wrapper (wraps `default`)

### Custom Plugin

`_plugins/highlight_linedivs.rb` extends Rouge's `{% highlight %}` tag with a `linedivs` option, which wraps each line in a `<div>` (enabling per-line CSS targeting for features like line highlighting). Usage in posts:

```liquid
{% highlight python linedivs %}
code here
{% endhighlight %}
```

### Post Front Matter

```yaml
---
layout: post
title: Post Title
categories: 分类
tags: tag1 tag2
toc: true        # optional: enables table of contents sidebar
mathjax: true    # optional: enables MathJax rendering
---
```

### Navigation & Data

- `_data/navigation.yml` — header nav links
- `_data/tool-sidebar.yml` — sidebar links for tool pages

### Pre-commit Hooks

Configured in `.pre-commit-config.yaml`:
- YAML/JSON/XML validation, trailing whitespace, symlink checks
- Secret scanning via `ripsecrets`
- Image compression via `script/img_compress.sh` (requires `mozjpeg` and `pngquant` installed locally at `~/software/`)

### Vendored Submodule (raphael-publish)

`vendor/raphael-publish` is a git submodule (configured in `.gitmodules`, url `git@github.com:algony-tony/raphael-publish.git`, tracked branch `blog-integration`). It is a standalone React 18 + Vite + TypeScript app — a Markdown-to-公众号 typesetting tool — embedded as a tool page on the blog.

Build flow:
- `script/build-raphael.sh [target_dir] [--force]` runs `pnpm install --frozen-lockfile && pnpm build` inside the submodule (skipped if `vendor/raphael-publish/dist` already exists, unless `--force`), then copies `dist/*` into the target (default `tools/raphael-publish/`). Requires `pnpm`.
- `tools/raphael-publish/` is a generated artifact and is gitignored (`.gitignore` line `/tools/raphael-publish`) — never edit it by hand.
- `script/serve.sh` calls `build-raphael.sh` before serving; `deploy-push-gh-pages.sh` calls it with `--force` into `_site/tools/raphael-publish`.
- The tool page is linked from `_data/tool-sidebar.yml`.

Updating to a new raphael-publish version: run `script/update-submodules.sh` (or `script/update-submodules.sh vendor/raphael-publish`). It runs `git submodule update --remote` to advance the pointer to the latest commit on the tracked branch, then stages the bumped pointer. Review with `git diff --cached` and commit with a message like `Bump raphael-publish: <what changed>`.

### Deployment

`script/deploy-push-gh-pages.sh` builds the site and force-pushes the `_site/` output to the `gh-pages` branch of the repo from a sibling directory (`../algony-tony.github.io_site/`). Deployment is fully manual (build locally, then run this script). The only GitHub Actions workflow is TruffleHog secret scanning (`.github/workflows/`); there is no build/test CI.
