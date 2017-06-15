Introduction
============

For all these steps you need the `git-buildpackage` package installed.


Create a new EDUVPN package
=========================

1 Fork the package to: https://github.com/eduvpn-debian

2. Create a new git repository on your build system with the same
   name as your package and run `git init` in it

3. Download the released tarball for a package. make sure it is
   named `<name>-<version>.tar.bz2` or `.gz` or `.xz`

4. inside the new git repo run `gbp import-orig path/to/<name>-<version>.tar.bz2`

5. create the debian folder with content. Copy this from an other
   repo and modify or use `dh_make`.


Update existing package
=======================

0. Make new release of your software or ask upstream to make release. 
1. `git clone https://github.com/eduvpne-debian/<package> && cd <package>`

2. If the package has a watch file you can run `gbp import-orig --uscan`

3. If no watch file, add a watch file. Example:

   https://github.com/kernsuite-debian/sourcery/blob/master/debian/watch

   Documentation about watch file:

   https://wiki.debian.org/debian/watch 

   Otherwise download release tarball and run `gbp import-orig path/to/<package>-<version>.tar.gz`

4. increment version number using `dch -i`. Make sure release is set to `xenial`,
   or whatever the platform is you are packaging for. The version number depends
   a bit on the package but rule of thumb is start with `<upstream_version>-1`,
   and then continue with `<upstream_version>-1kern1` of you made a mistake and
   want to fix the package itself. `<upstream_version>-1kern2` after that, etc.
   Counting is reset to `<upstream_version>-1` in case of upstream release. We do
   this do be as compatible as possible with debian packages. Some of our package
   are or will be part of Debian at some point.


Building the package
====================

1. check if package builds with `gbp build-package` or `dpkg-buildpackage` to
   ignore the git stuff. Note that gbp doesn't build with uncommitted changes. 

2. To make sure everything builds on launchpad you could build inside an
   empty system to make sure the build dependencies are right. Your
   system probably has all kind of stuff installed, so it is wise to do
   it in a chroot. Debian has all kind of funky utilities for this, for example:

   https://pbuilder.alioth.debian.org/

   quick start:

    * `pbuilder --create` to create a chroot
    * `pdebuild` to build source package in chroot
    * You probably need to add the eduvpn PPA as a dependency to your chroot
      https://pbuilder.alioth.debian.org/#usingspecialaptsources

    Note that you don't *have* to use the chroot, it is just to make sure
    everything works. If changes are minimal al quick build test could be
    enough.

3. check if package installs. Preferably in an empty system (or docker image).


Uploading changes to github and launchpad
=========================================

1. If everything looks awesome run `gbp build-package --git-tag` to
   tag this version.

2. run `git push --all && git push --tags` to upload all your changes to github

3. run `debuild -S -sa` for building a source package in the parent

4. run `dput ppa:eduvpn/ppa ../<package_<version>_source.changes`
