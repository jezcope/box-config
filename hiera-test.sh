#!/bin/bash

hiera -dc /etc/puppet/hiera.yaml $1 ::fqdn=$(facter fqdn) ::osfamily=$(facter osfamily)
