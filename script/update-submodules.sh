#!/usr/bin/env bash
set -e # halt script on error

# Update git submodules to the latest commit on their tracked branch
# (as configured in .gitmodules), then stage the bumped pointer(s).
#
# Usage: update-submodules.sh [path ...]
#   path : one or more submodule paths to update (default: all submodules)
#
# After running, review `git diff --cached` and commit, e.g.:
#   git commit -m "Bump raphael-publish: <what changed>"

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
cd "${project_dir}"

# Resolve which submodule paths we operate on (args, or all if none given).
if [ "$#" -gt 0 ]; then
    paths=("$@")
else
    mapfile -t paths < <(git config --file .gitmodules --get-regexp '\.path$' | awk '{print $2}')
fi

# Pull latest from each submodule's configured branch.
git submodule update --remote --recursive "${paths[@]}"

# Show and stage any bumped pointers.
if git diff --quiet -- "${paths[@]}"; then
    echo "Submodules already up to date."
    exit 0
fi

echo "Submodule pointer changes:"
git submodule status "${paths[@]}"

git add "${paths[@]}"
echo
echo "Bumped pointer(s) staged. Review with: git diff --cached"
echo "Then commit, e.g.: git commit -m \"Bump raphael-publish: <what changed>\""
