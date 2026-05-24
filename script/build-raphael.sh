#!/usr/bin/env bash
set -e # halt script on error

# Build the raphael-publish vendor submodule and copy its dist into a target dir.
#
# Usage: build-raphael.sh [target_dir] [--force]
#   target_dir : where to copy dist/* (default: tools/raphael-publish)
#   --force    : rebuild even if vendor/raphael-publish/dist already exists

command -v pnpm >/dev/null 2>&1 || { echo "Error: pnpm is required but not installed."; exit 1; }

project_dir=$(dirname "$(dirname "$(readlink -f "$0")")")
cd "${project_dir}"

target_dir="${1:-tools/raphael-publish}"
force="${2:-}"
vendor_dir="vendor/raphael-publish"

if [ ! -d "${vendor_dir}/dist" ] || [ "${force}" = "--force" ]; then
    echo "Building raphael-publish..."
    ( cd "${vendor_dir}" && pnpm install --frozen-lockfile && pnpm build )
    echo "raphael-publish build complete."
fi

echo "Syncing raphael-publish dist -> ${target_dir}"
mkdir -p "${target_dir}"
cp -rf "${vendor_dir}/dist/"* "${target_dir}/"

# Drop raphael's bundled favicon link from the embedded copy so the tool page
# inherits the blog's own favicon (/favicon.ico) instead of switching to
# raphael's. raphael's standalone deploy keeps its favicon untouched.
if [ -f "${target_dir}/index.html" ]; then
    sed -i '/<link rel="icon"/d' "${target_dir}/index.html"
fi
