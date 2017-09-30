#!/bin/bash -ve

# create a repository and sync with the eduVPN public repository.
#
# package dependencies: aptly

KEY=9BF9BF69E5DDE77F5ABE20DC966A924CE91888D2
DIST=stretch
REPO=eduvpn

aptly publish drop ${DIST} || true
aptly repo drop ${REPO} || true

aptly repo create -architectures="amd64,i386" ${REPO}
aptly repo add ${REPO} build/*.deb
aptly publish -distribution=${DIST} -architectures="amd64,i386" repo ${REPO}
#aptly publish update -gpg-key=${KEY} stretch
gpg --export --armor ${KEY} > ~/.aptly/public/${REPO}.key
rsync -4rv --del ~/.aptly/public/* gimo@static.eduvpn.nl:/var/www/html/web/repo/debian

