#!/bin/bash -ve

# create a repository and sync with the eduVPN public repository.
#
# package dependencies: aptly

KEY=9BF9BF69E5DDE77F5ABE20DC966A924CE91888D2
REPO=eduvpn

# remove any old local repository
aptly publish drop stable || true
aptly publish drop stretch || true
aptly repo drop ${REPO} || true

# create a new repository
aptly repo create -architectures="amd64,i386,arm64" ${REPO}

# add the binary packages 
aptly repo add ${REPO} build/*.deb

# add the source packages
aptly repo add ${REPO} build/*.dsc

# localy publish the repository
aptly publish -gpg-key=${KEY} -distribution=stable -architectures="arm64,amd64,i386,all,source" repo ${REPO}
aptly publish -gpg-key=${KEY} -distribution=stretch -architectures="arm64,amd64,i386,all,source" repo ${REPO}

# export the key which was used during packaging
gpg --export --armor ${KEY} > ~/.aptly/public/${REPO}.key

# publish the repo online
rsync -4rv --del ~/.aptly/public/* gimo@static.eduvpn.nl:/var/www/html/web/app/linux/deb


