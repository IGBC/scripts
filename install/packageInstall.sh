#!/bin/bash

# find package manager (ordered by preference High to Low)
# After finding one set the install command and package list for the distro
# Also add any external repos. (TBC)

if which dnf; then
	pkgmgr='dnf -y install';
	pkglist=$rpmpkglist
	
	for i in $rpmrepolist; do
		dnf config-manager --add-repo $i
		dnf config-manager --enable-repo $i
	done	

elif which apt; then
	pkgmgr='apt -y install';
	pkglist=$debpkglist
	
	for i in $debrepolist; do
		add-apt-repository $i
	done
	apt update

elif which apt-get; then
	pkgmgr='apt-get -y install';
	pkglist=$debpkglist

	for i in $debrepolist; do
		add-apt-repository $i
	done
	apt-get update

elif which pacman; then
	pkgmgr='pacman --yes -sy'
	pkglist=$aurpkglist
fi;

# Then you can execute the generic command
$pkgmgr $pkglist

# The variables are left set so you can use them later.
