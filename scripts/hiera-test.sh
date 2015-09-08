#!/bin/bash

hiera -dc /etc/puppetlabs/code/hiera.yaml $1 ::fqdn=$(facter fqdn) ::osfamily=$(facter osfamily)
