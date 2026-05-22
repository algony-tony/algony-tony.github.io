#!/usr/bin/env bash
set -e # halt script on error

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
cd "${project_dir}"

echo "Preparing raphael-publish for local serve..."
script/build-raphael.sh

bundle exec jekyll serve --drafts --livereload --port 2000
