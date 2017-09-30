#!/bin/bash -ve

# Will update the package repository on new upstream release.
# Will only work if the build dependenices and scripts don't require a change
# Run from the debian package source folder.
# package dependencies: git-buildpackage and devscripts.

dh_clean
git pull
git checkout upstream
git checkout master
git clean -f -d
gbp import-orig --uscan
gbp dch -D stable
git commit debian/changelog -m "new upstream release"
gbp buildpackage --git-tag
git push --all
git push --tags
