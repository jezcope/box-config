Apt::Source<| |> ~> Exec['apt_update'] -> Package<| |>

if $::lsbdistid == 'Ubuntu' and $::architecture == 'amd64' {
  exec { 'enable Ubuntu multiarch':
    command => '/usr/bin/dpkg --add-architecture i386',
    unless => '/usr/bin/dpkg --print-foreign-architectures | /bin/grep i386 > /dev/null',
    notify => Exec['apt_update'],
  }
}

$box_username = hiera("username", "jez")
$box_usergrp  = hiera("usergrp",  $box_username)
$box_homedir  = hiera("homedir",  "/home/$box_username")

hiera_include('classes')
