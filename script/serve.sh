#!/usr/bin/env bash
set -e # halt script on error

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
cd "${project_dir}"

echo "Preparing raphael-publish for local serve..."
mkdir -p tools/raphael-publish

# Check if dist exists, if not build it
if [ ! -d "vendor/raphael-publish/dist" ]; then
    echo "Building raphael-publish..."
    cd vendor/raphael-publish
    pnpm install --frozen-lockfile
    pnpm build
    cd "${project_dir}"
fi

# Sync to tools directory
if [ -d "vendor/raphael-publish/dist" ]; then
    cp -rf vendor/raphael-publish/dist/* tools/raphael-publish/
fi

bundle exec jekyll serve --drafts --livereload --port 2000
