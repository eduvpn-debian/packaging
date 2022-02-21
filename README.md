Introduction
============

This is the start point for all eduVPN related packaging work. Please report any issues with
the packages in the issue tracker of this repository.

Every package has its own git repo in the eduvpn-debian github project. On every release
a the package is imported, the debian files are updated and a new package is uploaded to the repository.

We try to follow the Debian workflow as much as possible. To read more about this check out the
git-buildpackage documentation:

http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.html

Or if you need to know more about Debian packaging in general read the maintainers guide:

https://www.debian.org/doc/manuals/maint-guide/

The commands below have been tested on Ubuntu 17.04 and Debian 9, but should work with any
modern Debian based distribution.

Enable the repository
=====================

To enable the official eduVPN package repository to your system run as root:

```
# apt install apt-transport-https
# curl -L https://repo.eduvpn.org/debian/eduvpn.key  | apt-key add -
# echo "deb https://repo.eduvpn.org/debian/ stretch main" > /etc/apt/sources.list.d/eduvpn.list
# apt update
```

Making the packages
===================

Some eduVPN packages depend on each other, also during build time. The easiest
way to satisfy these depenencies is to just add the eduVPN repository to your system.
This will enable the auto installation of required eduVPN packages during the build.

For all these steps you need the `git-buildpackage` package installed. The signing
of the packages happens with gnupg, so make sure you have that also installed
and that your keypair is available for signing.

Also make sure you set the Debian invironment variables, which will be used
in updating the changelog entry. The information needs to match your gnupg
key information. You can optionally specify a parallel flag to speed up
compilation.

```
DEBEMAIL="gijs@pythonic.nl"
DEBFULLNAME="Gijs Molenaar (launchpad ppa build key)"
DEB_BUILD_OPTIONS="parallel=32"
```

Create a new eduVPN package
---------------------------

1. Create a new git repository on your build system with the same
   name as your package and run `git init` in it

2. Download the released tarball for a package. make sure it is
   named `<name>-<version>.tar.bz2` or `.gz` or `.xz`

3. inside the new git repo run `gbp import-orig path/to/<name>-<version>.tar.bz2`

4. create the debian folder with content. Copy this from an other
   repo and modify or use `dh_make`. Read the debian maintainers guide if you
   have no idea how to make a package.


Update existing package
-----------------------

1. Make new release of your software or ask upstream to make release. 

2. `git clone https://github.com/eduvpn-debian/<package> && cd <package>`

3. If you already have a checkout, cleanup the source folder. `dh_clean` should
   work, otherwise run `git clean -f -d`.

4. run `gbp import-orig --uscan` to update the package to the latest version.

5. If gbp complains there is no upstream branch, run `checkout upstream` to create
   a local checkout and switch back to master with `checkout master`, repeat step 3.

6. run `gbp dch -D stable` and customize `debian/changelog` to your needs. Usualy one
   line with `new upstream release` should be enough. 
   
7. Make the changelog entry final `git commit debian/changelog -m "new upstream release"`

8. Check if the package builds, if not you need to modify the `debian` files, like adding
   missing dependencies in `debian/control`.
   
An example script containing these steps can be found here:

https://github.com/eduvpn-debian/packaging/blob/master/new_upstream.sh


Building the package
--------------------

1. install the build dependencies by running `mk-build-deps -i` in the source root.
   You can remove the requirements `deb` package in the source root afterwards.

2. check if package builds with `gbp build-package`. If you are not a eduVPN
   repository maintainer, you should disable the signing of the resulting packages
   (by adding `-us` and `-uc` flags to the `gbp` command), or update the changelog
   entry.

3. (optional) To make sure everything builds you could build inside an
   empty system to make sure the build dependencies are right. Your build
   system probably has all kind of packages installed that falsely satisfy build
   dependencies, so it is wise to do it in a clean chroot. Debian has all kind of
   funky utilities for this, for example:

   https://pbuilder.alioth.debian.org/

   quick start:

    * `pbuilder --create` to create a chroot
    * `pdebuild` to build source package in chroot
    * You probably need to add the eduVPN PPA as a dependency to your chroot
      https://pbuilder.alioth.debian.org/#usingspecialaptsources

    Note that you don't *have* to use the chroot, it is just to make sure
    everything works. If changes are minimal al quick build test could be
    enough.

    NOTE: when building on ubuntu 21.10 make sure you use xz as compressor:
          gbp buildpackage --git-ignore-new --git-builder='debuild -i -I -Zxz'

4. check if package installs. Preferably in an empty system (or docker image).

An example script for building all eduVPN packages can be found here:

https://github.com/eduvpn-debian/packaging/blob/master/build_all.sh

Publishing the package
----------------------

There are various package publishing tools available, but aptly seems quite
complete. https://www.aptly.info

Check out this script for an example on how to create a repository locally,
and then publish this remotely:

https://github.com/eduvpn-debian/packaging/blob/master/repo_upload.sh


Uploading changes to github
===========================

1. If everything looks awesome run `gbp build-package --git-tag` to
   tag this version.

2. run `git push --all && git push --tags` to upload all your changes to github

