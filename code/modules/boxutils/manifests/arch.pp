class boxutils::arch {

  Exec {
    path => '/usr/bin',
  }

  exec { 'enable arch multilib':
    command => "sed -iorig '/#\\[multilib\\]/{N;s/#//g}' /etc/pacman.conf",
    unless => "grep '^\\[multilib\\]$' /etc/pacman.conf > /dev/null",
    notify => Exec['pacman update'],
  }

  exec { 'enable personal repository':
    command => 'echo -e "\n[jez]\nServer = https://dl.dropboxusercontent.com/u/4492973/pacman\nSigLevel = Optional" >> /etc/pacman.conf',
    unless => "grep '^\\[jez\\]$' /etc/pacman.conf > /dev/null",
    notify => Exec['pacman update'],
  }

  exec { 'pacman update':
    command => 'pacman -Sy',
    refreshonly => true,
  }

  Exec['pacman update'] -> Package<| |>

}
