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


Enable the repository
=====================

as root run:

```
# apt install apt-transport-https
# curl -L https://repo.eduvpn.org/debian/eduvpn.key  | apt-key add -
# echo "deb https://repo.eduvpn.org/debian/ stretch main" > /etc/apt/sources.list.d/eduvpn.list
# apt update
# apt install eduvpn-client
```

Making the packages
===================

For all these steps you need the `git-buildpackage` package installed.

Create a new EDUVPN package
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

2. `git clone https://github.com/eduvpne-debian/<package> && cd <package>`

3. run `gbp import-orig --uscan` to update the package to the latest version.

4. If gbp complains there is no upstream branch, run `checkout upstream` to create
   a local checkout and switch back to master with `checkout master`, repeat step 3.

4. run `gbp dch -D stable` and customize `debian/changelog` to your needs. Usualy one
   line with `new upstream release` should be enough. Check if the package builds, if
   not you need to modify the `debian` files, like adding missing dependencies in
   `debian/control`.


Building the package
--------------------

1. install the build dependencies by running `mk-build-deps -i` in the source root.
   You can remove the requirements `deb` package in the source root afterwards.

2. check if package builds with `gbp build-package`

3. To make sure everything builds you could build inside an
   empty system to make sure the build dependencies are right. Your build
   system probably has all kind of packages installed that falsely satisfy build
   dependencies, so it is wise to do it in a clean chroot. Debian has all kind of
   funky utilities for this, for example:

   https://pbuilder.alioth.debian.org/

   quick start:

    * `pbuilder --create` to create a chroot
    * `pdebuild` to build source package in chroot
    * You probably need to add the eduvpn PPA as a dependency to your chroot
      https://pbuilder.alioth.debian.org/#usingspecialaptsources

    Note that you don't *have* to use the chroot, it is just to make sure
    everything works. If changes are minimal al quick build test could be
    enough.

4. check if package installs. Preferably in an empty system (or docker image).


Uploading changes to github
===========================

1. If everything looks awesome run `gbp build-package --git-tag` to
   tag this version.

2. run `git push --all && git push --tags` to upload all your changes to github

