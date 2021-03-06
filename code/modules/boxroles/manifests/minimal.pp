class boxroles::minimal {

  include boxutils::dotfiles

  case $::osfamily {
    'Arch':   { include boxutils::arch }
    'Debian': { include boxutils::debian }
  }

  user { $box_username:
    ensure => present,
  }

  file { $box_homedir:
    ensure => directory,
    owner => $box_username,
    group => $box_usergrp,
  }

  package {
    ['git', 'zsh']:
      ensure => present;
  }

  file { '/usr/local/bin/box-config':
    ensure => link,
    target => '/etc/box-config/scripts/box-config',
    force => true,
  }

}
