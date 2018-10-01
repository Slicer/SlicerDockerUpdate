#!/bin/bash

set -ex

export PATH=/usr/bin:$PATH

script_dir=$(cd $(dirname $(readlink -f "$0")) || exit 1; pwd)

token_file=$script_dir/SLICERDOCKER_GITHUB_TOKEN

if [[ ! -f $token_file ]]; then
  echo "$token_file not found"
  exit 1
fi

export SLICERDOCKER_GITHUB_TOKEN=$(cat $token_file | sed 's/^ *//g' | sed 's/ *$//g')

source ${script_dir}/update-build-publish.sh
