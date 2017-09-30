#!/bin/bash -ve

# checks if there is an update available for any eduVPN package.
# Will only print out information.

PACKAGES=`cat packages`
pushd build

for i in $PACKAGES; do
	pushd $i;
	uscan;
	popd;
done
