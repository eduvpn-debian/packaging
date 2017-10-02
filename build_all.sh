#!/bin/bash -ve

# this script will clone all eduVPN package repositories and build them
# it will install required dependencies during the run, so it requires sudo access
#
# package dependencies: sudo devscripts git git-buildpackage equivs

if [ ! -d "build" ]; then
    mkdir build;
fi

pushd build

for i in `cat ../packages`; do
    if [ ! -f "$i.build" ]; then
        if [ ! -d "$i" ]; then
            git clone https://github.com/eduvpn-debian/$i
        fi
        sudo apt --fix-broken install
        pushd $i
        dh_clean
        git pull
        sudo mk-build-deps -i || true
        sudo apt --fix-broken install
        rm -f *-build-deps_*_all.deb 
        dh_clean
        gbp buildpackage --git-ignore-new -us -uc
        popd
        touch $i.build
    fi
done
