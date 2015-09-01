class boxutils::arch {

  exec { 'enable arch multilib':
    command => "sed -iorig '/#\\[multilib\\]/{N;s/#//g}' /etc/pacman.conf",
    unless => "grep '^\\[multilib\\]$' /etc/pacman.conf > /dev/null",
    path => '/usr/bin',
  }

  Exec['enable arch multilib'] -> Package['skype']

}
