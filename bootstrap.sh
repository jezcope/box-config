#!/bin/bash

sudo apt-get install git puppet ssh xclip
sudo puppet apply /etc/puppet/default.pp
