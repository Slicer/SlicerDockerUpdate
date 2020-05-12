#!/bin/bash

set -eo pipefail

# Ensure an recent version of git is used the official Slicer build machine
# See https://github.com/Slicer/DashboardScripts/blob/master/metroplex.sh
if [[ -f /home/kitware/.nix-profile/etc/profile.d/nix.sh ]]; then
  source /home/kitware/.nix-profile/etc/profile.d/nix.sh
else
  export PATH=/usr/bin:$PATH
fi

script_dir=$(cd $(dirname $(readlink -f "$0")) || exit 1; pwd)
slicer_dir=$script_dir/Slicer
slicer_docker_dir=$script_dir/SlicerDocker

function report {
  NOW=$(date +'%T %D')
  echo "--------------------------------------------------------------------------------"
  echo "$NOW - $1"
  echo "--------------------------------------------------------------------------------"
}

function die {
  echo $1
  exit 1
}

[[ ! -d $slicer_dir ]] && die "Slicer directory not found [$slicer_dir]"
[[ ! -d $slicer_docker_dir ]] && die "SlicerDocker directory not found [$slicer_docker_dir]"

report "Pulling Slicer changes [$slicer_dir]"
#report "HOME: $HOME - USER: $USER - LOGNAME:$LOGNAME - SSH_AGENT_PID:$SSH_AGENT_PID - SSH_AUTH_SOCK:$SSH_AUTH_SOCK"
cd $slicer_dir
git reset --hard HEAD
git checkout master
git fetch origin
git reset --hard origin/master


report "Pulling SlicerDocker changes into [$slicer_docker_dir]"
cd $slicer_docker_dir
git reset --hard HEAD
git checkout master
git fetch origin
git reset --hard origin/master

report "Update SlicerDocker [$slicer_docker_dir/slicer-base/update.sh $slicer_dir]"
$slicer_docker_dir/slicer-base/update.sh $slicer_dir

report "Build docker images from [$slicer_docker_dir]"
cd $slicer_docker_dir
make slicer-base
make slicer-base.push

report "Pushing SlicerDocker changes [$slicer_docker_dir]"
# ... but if there is no token, bail
if [[ "$SLICERDOCKER_GITHUB_TOKEN" == "" ]]; then
  echo "-> Skipping SlicerDocker repository update: SLICERDOCKER_GITHUB_TOKEN env. variable is not set"
  exit 0
fi
cd $slicer_docker_dir
remote=https://${SLICERDOCKER_GITHUB_TOKEN}@github.com/Slicer/SlicerDocker.git
git push $remote master > /dev/null 2>&1

