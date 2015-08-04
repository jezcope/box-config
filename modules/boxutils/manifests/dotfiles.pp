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
    source   => 'git@github.com:jezcope/dotfiles.git',
    require  => Package['git'],
    user     => $box_username,
  }

  [".gnupg", "bin", ".config/awesome"].each |String $dir| {
    file { "$box_homedir/$dir":
      ensure => directory,
      owner => $box_username,
      group => $box_usergrp,
    }
  }

  $dotlinks.each |String $file| {
    file { "$box_homedir/.${file}":
      target => "$box_dotfiles/${file}",
      ensure => link,
      owner  => $box_username,
      group  => $box_usergrp,
    }
  }

  $otherlinks.each |String $target, String $location| {
    file { "$box_homedir/${location}":
      target => "$box_dotfiles/$target",
      ensure => link,
      owner  => $box_username,
      group  => $box_usergrp,
    }
  }

}

