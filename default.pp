$box_username = hiera("username", "jez")
$box_usergrp  = hiera("usergrp",  $box_username)
$box_homedir  = hiera("homedir",  "/home/$box_username")

case $osfamily {
  'Debian': { include boxutils::debian }
  #'Archlinux': { include boxutils::arch }
}

hiera_include('classes')
