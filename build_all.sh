#!/bin/bash -ve

# this script will clone all eduVPN package repositories and build them
# it will install required dependencies during the run, so it requires sudo access
#
# package dependencies: sudo devscripts git git-buildpackage equivs

# set to true if this a maintainer script run (sign and or update enable)
MAINT= true

if [ ! -d "build" ]; then
    mkdir build;
fi

pushd build

for i in `cat ../packages`; do
    if [ ! -f "$i.build" ]; then
	# checkout if don't exist yet
        if [ ! -d "$i" ]; then
	    if [ "${MAIN}" = true ] ; then
               git clone git@github.com:eduvpn-debian/$i.git
            else
               git clone https://github.com/eduvpn-debian/$i
	    fi
        fi

	# fix any package problems before proceding
        sudo apt --fix-broken install
        pushd $i

	# debian helper clean, clean up potential old build artifacts
        dh_clean

	# make sure we have the latest version
        git pull

	# install build dependencies
        sudo mk-build-deps -i || true

	# install missing depenencies
        sudo apt --fix-broken install

	# remove temporary dependencies file

        rm -f *-build-deps_*_all.deb 

	# clean
        dh_clean

	# build package, -us and -uc mean don't sign
	if [ "${MAIN}" = true ] ; then
	    gbp buildpackage --git-ignore-new 
	else
	    gbp buildpackage --git-ignore-new  -us -uc
	fi

        popd

	# build is skipped if there is a build file present
        touch $i.build
    fi
done
