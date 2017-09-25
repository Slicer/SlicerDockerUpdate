#!/bin/bash

set -ex

export PATH=/usr/bin:$PATH

script_dir=$(cd $(dirname $(readlink -f "$0")) || exit 1; pwd)

export SLICERDOCKER_GITHUB_TOKEN=$(cat $script_dir/SLICERDOCKER_GITHUB_TOKEN | sed 's/^ *//g' | sed 's/ *$//g')

source ${script_dir}/update-build-publish.sh
