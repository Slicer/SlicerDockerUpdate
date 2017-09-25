#!/bin/bash

set -ex

export PATH=/usr/bin:$PATH

script_dir=$(cd $(dirname $(readlink -f "$0")) || exit 1; pwd)
slicer_dir=$script_dir/Slicer
slicer_docker_dir=$script_dir/SlicerDocker
# logfile=$script_dir/lastupdate-log.txt

# Sanity checks
if [[ ! -d $slicer_dir ]]; then
  echo "Slicer directory not found [$slicer_dir]"
  exit 1
fi
if [[ ! -d $slicer_docker_dir ]]; then
  echo "SlicerDocker directory not found [$slicer_docker_dir]"
  exit 1
fi

NOW=$(date +'%T %D')

# rm -f $logfile

#------------------------------------------------------------------------------
echo "" #  >> $logfile
echo "$NOW - Pulling Slicer changes" #  >> $logfile
#echo "HOME: $HOME - USER: $USER - LOGNAME:$LOGNAME -
#SSH_AGENT_PID:$SSH_AGENT_PID - SSH_AUTH_SOCK:$SSH_AUTH_SOCK" >> $logfile
pushd $slicer_dir > /dev/null
(git checkout master &&
  git reset --hard git-svn &&
  git svn rebase) #  >> $logfile 2>&1
popd > /dev/null

#------------------------------------------------------------------------------
echo "" #  >> $logfile
echo "$NOW - Pulling SlicerDocker changes" #  >> $logfile
pushd $slicer_docker_dir > /dev/null
(git reset --hard HEAD &&
  git checkout master &&
  git fetch origin &&
  git reset --hard origin/master) # >> $logfile 2>&1
popd > /dev/null

#------------------------------------------------------------------------------
pushd $slicer_docker_dir > /dev/null

echo "" # >> $logfile
echo "$NOW - Update SlicerDocker" #  >> $logfile
./slicer-base/update.sh $slicer_dir #  >> $logfile 2>&1

echo "" # >> $logfile
echo "$NOW - Build docker images" # >> $logfile
make build-all # >> $logfile 2>&1

popd > /dev/null

#------------------------------------------------------------------------------
echo "" # >> $logfile
echo "$NOW - Pushing SlicerDocker changes" #  >> $logfile
pushd $slicer_docker_dir > /dev/null
if [[ $SLICERDOCKER_GITHUB_TOKEN ]]; then
  remote=https://${SLICERDOCKER_GITHUB_TOKEN}@github.com/thewtex/SlicerDocker.git
  git push $remote master > /dev/null 2>&1 #  >> $logfile 2>&1
else
  echo "Skipping SlicerDocker update: SLICERDOCKER_GITHUB_TOKEN env. variable is not set" # >> $logfile
fi
popd > /dev/null

#------------------------------------------------------------------------------
pushd $slicer_docker_dir > /dev/null
echo "" # >> $logfile
echo "$NOW - Pushing SlicerDocker images" # >> $logfile
make push-all #  >> $logfile 2>&1
popd > /dev/null

#------------------------------------------------------------------------------
$slicer_docker_dir/remove-dangling-images.sh
