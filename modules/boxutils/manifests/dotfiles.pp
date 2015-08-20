class boxutils::dotfiles {

  $box_dotfiles = "$box_homedir/.dotfiles"

  $dotlinks = ['zshrc', 'zshenv', 'zsh', 'vimrc', 'vim', 'emacs.d',
               'pentadactyl', 'pentadactylrc', 'xmonad', 'gitconfig',
               'gitignore.global', 'htmltidy.conf', 'ackrc', 'keysnail.js']
  $otherlinks = {
    'gpg.conf'      => '.gnupg/gpg.conf',
    'dirmngr.conf'  => '.gnupg/dirmngr.conf',
    'scdaemon.conf' => '.gnupg/scdaemon.conf',
    'certs'         => '.gnupg/certs',
    'awesomerc.lua' => '.config/awesome/rc.lua',
    'texmf'         => 'texmf',
    'sharedbin'     => 'bin/shared',
  }

  vcsrepo { $box_dotfiles:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jezcope/dotfiles.git',
    require  => [User[$box_username], File[$box_homedir], Package['git']],
    user     => $box_username,
    alias    => 'dotfiles',
  }

  [".gnupg", "bin", ".config", ".config/awesome"].each |String $dir| {
    file { "$box_homedir/$dir":
      ensure => directory,
      owner => $box_username,
      group => $box_usergrp,
      require => Vcsrepo['dotfiles'],
    }
  }

  $dotlinks.each |String $file| {
    file { "$box_homedir/.${file}":
      target => "$box_dotfiles/${file}",
      ensure => link,
      owner  => $box_username,
      group  => $box_usergrp,
      require => Vcsrepo['dotfiles'],
    }
  }

  $otherlinks.each |String $target, String $location| {
    file { "$box_homedir/${location}":
      target => "$box_dotfiles/$target",
      ensure => link,
      owner  => $box_username,
      group  => $box_usergrp,
      require => Vcsrepo['dotfiles'],
    }
  }

}

