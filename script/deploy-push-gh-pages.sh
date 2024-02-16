#!/bin/bash

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
site_dir="${project_dir}_site"


if [ ! -d "$site_dir" ]; then
    echo "create directory ${site_dir}"
    mkdir "$site_dir"

    echo "git init and add remote origin"
    cd "${site_dir}"
    git init
    git remote add origin git@github.com:algony-tony/algony-tony.github.io.git
fi


# build
cd "${project_dir}"
git checkout master || { echo "checkout master failed"; exit 1; }
bundle exec jekyll build --future --trace

# deploy
rm -rf ${site_dir}/*
cp -rf ${project_dir}/_site/* "${site_dir}/"

cd "${site_dir}/"
git add -A
git commit -m "Deploy to gh-pages"

git push --force origin master:gh-pages

