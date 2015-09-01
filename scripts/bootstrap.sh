#!/bin/bash

[ "$EUID" -eq 0 ] || exec sudo bash "$0" "$@"

puppet_dir=$(dirname $(readlink -f $(dirname $0)))

if which apt-get &>/dev/null ; then
    apt-get update
    apt-get install puppet
elif which pacman &>/dev/null ; then
    pacman -Sy
    pacman -S puppet
fi

node_data=$puppet_dir/node/$(facter fqdn).yaml

if [ ! -f $node_data ]; then
    cp $puppet_dir/templates/node-data.yaml $node_data
fi

vi $node_data

puppet apply $puppet_dir/code/default.pp
