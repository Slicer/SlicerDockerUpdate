#!/bin/bash

#
# This script checkout Slicer & SlicerDocker sources
#

set -ex

script_dir=$(cd $(dirname $(readlink -f "$0")) || exit 1; pwd)

slicer_dir=$script_dir/Slicer
slicerdocker_dir=$script_dir/SlicerDocker

#
# Check Slicer sources
#
if [[ ! -d $slicer_dir ]];  then
  git clone git://github.com/Slicer/Slicer $slicer_dir

  pushd $slicer_dir > /dev/null

  # Instructions from https://www.slicer.org/wiki/Documentation/Nightly/Developers/Build_Instructions#CHECKOUT_slicer_source_files
  git svn init http://svn.slicer.org/Slicer4/trunk
  git update-ref refs/remotes/git-svn refs/remotes/origin/master
  git checkout master
  git svn rebase

  git config --global svn.rmdir true

  popd > /dev/null

fi

#
# Checkout SlicerDocker sources
#
if [[ ! -d $slicerdocker_dir ]]; then
  git clone git://github.com/thewtex/SlicerDocker $slicerdocker_dir
fi

#
# Associate slicebot user with SlicerDocker checkout
#
pushd $slicerdocker_dir > /dev/null

git config user.name "Slicer Bot"
git config user.email "slicerbot@slicer.org"

popd > /dev/null
