#!/bin/bash

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
site_dir="${project_dir}_site"

# Check required tools
command -v pnpm >/dev/null 2>&1 || { echo "Error: pnpm is required but not installed."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Error: node is required but not installed."; exit 1; }


if [ ! -d "$site_dir" ]; then
    echo "create directory ${site_dir}"
    mkdir "$site_dir"

    echo "git init and add remote origin"
    cd "${site_dir}"
    git init
    git remote add origin git@github.com:algony-tony/algony-tony.github.io.git
fi


# build Jekyll
cd "${project_dir}"
git checkout master || { echo "checkout master failed"; exit 1; }
bundle exec jekyll build --future --trace

# build raphael-publish and copy its dist into the Jekyll _site
"${project_dir}/script/build-raphael.sh" "${project_dir}/_site/tools/raphael-publish" --force

# deploy
rm -rf ${site_dir}/*
cp -rf ${project_dir}/_site/* "${site_dir}/"
touch "${site_dir}/.nojekyll"

cd "${site_dir}/"
git add -A
git commit -m "Deploy to gh-pages"

git push --force origin master:gh-pages
