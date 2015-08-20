$box_username = hiera("username", "jez")
$box_usergrp  = hiera("usergrp",  $box_username)
$box_homedir  = hiera("homedir",  "/home/$box_username")

hiera_include('classes')
