#!/usr/bin/env bash
set -e # halt script on error

bundle exec jekyll build --drafts
bundle exec htmlproofer ./_site --disable-external
