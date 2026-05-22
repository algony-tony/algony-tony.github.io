#!/usr/bin/env bash
set -e # halt script on error

# 从所有远端拉取变化，本地自动删除远端已删除的分支和标签
git fetch --all --prune
