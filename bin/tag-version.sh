#!/usr/bin/env bash

# set -ex

today=$(date +%Y%m%d)
vrsfile=VERSION.cmake
vrs="$1"

# check we are the top of an ecbuild project
[[ ! -f $PWD/CMakeLists.txt ]] && echo "current directory is not a valid ecbuild project" && exit 1
[[ ! -f $vrsfile ]] && echo "could not find $vrsfile" && exit 1

# get current version
current=$(grep _VERSION_STR $vrsfile | perl -pi -e 's/([\{\}\$\w\s\(])*"([0-9\.\-a-zA-Z]+)"([\w\s\)])*/\2/' )

# usage

if [ -z $1 ]
then
   echo "current version is '$current'"
   echo "usage: $0 <next version>"
   exit 1
fi

# make sure git has no changes

if [ ! "$(git status --porcelain)" == "" ]
then
  echo ">>> 'git stauts' returns a non clean state"
  echo ">>> " $(git status --porcelain)
  echo ">>>   Cannot proceed -- aborting"
  exit 1
fi

echo "version: $current -> $vrs"

if [ "$current" == "$vrs" ]
then
  echo "error: new version '$vrs' is same as current '$current'"
  exit 1
fi

# tag version

perl -pi -e "s/\"[0-9\.\-a-zA-Z]+\"/\"$vrs\"/" $vrsfile

# git ci $vrsfile -m "tagged version $vrs"

echo
echo "NOTE: don't forget to 'git push --tags [origin branch]' to propagate these changes"
echo
