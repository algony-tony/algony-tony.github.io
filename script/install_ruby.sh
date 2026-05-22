#!/usr/bin/env bash
# One-time setup runbook for a fresh machine. Run steps as needed rather than
# end-to-end; some commands (e.g. the initial `ruby -v`) are diagnostics that
# may fail before Ruby is installed, so this intentionally does not use `set -e`.

# 查看 ruby 版本
ruby -v

# 安装 Rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

rbenv -v

# List all of the versions of Ruby available for installation through Rbenv with
rbenv install -l

# Suggested build environment
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment

# install (keep in sync with the `ruby` pin in Gemfile)
rbenv install 3.2.2

# to activate this Ruby version as the new default
rbenv global 3.2.2

gem install jekyll bundler

# update bundler
gem update bundler

# update jekyll
gem update jekyll

# change to repo dir
bundle install

# update all gem version in project
bundle update