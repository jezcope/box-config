#!/bin/bash

[ "$EUID" -eq 0 ] || exec sudo bash "$0" "$@"

if which apt-get &>/dev/null ; then
    apt-get update
    apt-get install puppet
elif which pacman &>/dev/null ; then
    if ! grep '\[jez\]' /etc/pacman.conf > /dev/null; then
        tee -a /etc/pacman.conf > /dev/null <<EOF
[jez]
Server = https://dl.dropboxusercontent.com/u/4492973/pacman
SigLevel = Optional
EOF
    fi
    pacman -Sy
    pacman -S puppet3
    if [ -f /etc/puppet/puppet.conf.pacorig ]; then
        mv /etc/puppet/puppet.conf.pacorig /etc/puppet/puppet.conf
    fi
fi

node_data=/etc/puppet/hieradata/node/$(facter fqdn).yaml

if [ ! -f $node_data ]; then
    cp /etc/puppet/template.yaml $node_data
fi

vi $node_data

puppet apply /etc/puppet/default.pp
