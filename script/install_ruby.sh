
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

# install
rbenv install 3.1.3

# to activate this Ruby version as the new default
rbenv global 3.1.3

gem install jekyll bundler

# change to repo dir
bundle install
