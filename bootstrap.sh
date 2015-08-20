#!/bin/bash

sudo apt-get install puppet

node_data=/etc/puppet/hieradata/node/$(facter fqdn).yaml

if [ ! -f $node_data ]; then
    cp /etc/puppet/template.yaml $node_data
fi

sudoedit $node_data

sudo puppet apply /etc/puppet/default.pp
