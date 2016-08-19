class boxutils::dotfiles {

  $box_dotfiles = "$box_homedir/.dotfiles"

  $dotlinks = ['zshrc', 'zshenv', 'zshenv.path', 'zsh',
               'vimrc', 'vim', 'emacs.d',
               'pentadactyl', 'pentadactylrc',
               'vimperatorrc', 'vimperator',
               'xmonad', 'gitconfig',
               'gitignore.global', 'htmltidy.conf', 'ackrc', 'keysnail.js']
  $otherlinks = {
    'gpg.conf'      => '.gnupg/gpg.conf',
    'gpg-agent.conf' => '.gnupg/gpg-agent.conf',
    'dirmngr.conf'  => '.gnupg/dirmngr.conf',
    'scdaemon.conf' => '.gnupg/scdaemon.conf',
    'certs'         => '.gnupg/certs',
    'awesomerc.lua' => '.config/awesome/rc.lua',
    'texmf'         => 'texmf',
    'sharedbin'     => 'bin/shared',
    'applications/org-protocol.desktop' => '.local/share/applications/org-protocol.desktop',
  }
  $systemd_units = [
  ]

  File {
    owner  => $box_username,
    group  => $box_usergrp,
  }

  exec { 'git clone dotfiles':
    command => "/usr/bin/git clone https://github.com/jezcope/dotfiles.git $box_dotfiles",
    creates => $box_dotfiles,
    user => $box_username,
    cwd => '/tmp',
    require => [Package['git'], File[$box_homedir]],
  }

  [".gnupg", "bin", ".config", ".config/awesome",
   ".config/systemd", ".config/systemd/user",
   ".local", ".local/share", ".local/share/applications"].each |String $dir| {
    file { "$box_homedir/$dir":
      ensure => directory,
      force => true,
      require => Exec['git clone dotfiles'],
    }
  }

  $dotlinks.each |String $file| {
    file { "$box_homedir/.${file}":
      target => "$box_dotfiles/${file}",
      ensure => link,
      force => true,
      require => Exec['git clone dotfiles'],
    }
  }

  $otherlinks.each |String $target, String $location| {
    file { "$box_homedir/${location}":
      target => "$box_dotfiles/$target",
      ensure => link,
      force => true,
      require => Exec['git clone dotfiles'],
    }
  }

  $systemd_units.each |String $file| {
    file { "$box_homedir/.config/systemd/user/$file":
      ensure => file,
      content => template("$box_dotfiles/systemd/user/$file.erb"),
      require => Exec['git clone dotfiles'],
    }
  }

  file { "$box_homedir/.config/awesome/localprefs.lua":
    source => "$box_dotfiles/awesome_localprefs_example.lua",
    replace => no,
    require => Exec['git clone dotfiles'],
  }

  exec { 'update-desktop-database':
    command => "/usr/bin/update-desktop-database $box_homedir/.local/share/applications",
    refreshonly => true,
    user => $box_username,
    subscribe => File["$box_homedir/.local/share/applications/org-protocol.desktop"],
  }

}

