#!/bin/bash
#
# Verify the required ruby version is installed.
#

die() {
    echo "$@" >&2
    exit 1
}

command -v ruby >/dev/null || die "ruby not found in the PATH."
ruby_version=$(ruby --version | cut -f2 -d' ' | cut -f1 -d'p')
ruby_required=$(cat .ruby-version)
test "x$ruby_required" != "x" ||
  die "Could not read .ruby-version file."
test "x$ruby_version" = "x$ruby_required" ||
  die "Required ruby version $ruby_required not found (ruby $ruby_version)"

echo "Ruby version is ok (ruby $ruby_version)"
