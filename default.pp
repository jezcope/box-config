node default {
  include apt
  #include vcsrepo

  $box_username = jez
  $box_usergrp = $box_username

  apt::source { 'dropbox':
    location => 'http://linux.dropbox.com/ubuntu',
    repos => 'main',
    key => {
      id => '1C61A2656FB57B7E4DE0F4C1FC918B335044912E',
      server => 'pgp.mit.edu',
    },
    before => Package['dropbox'],
  }
  
  package {
    ['aptitude', 'git', 'bzr', 'mercurial', 'cvs',
     'build-essential',
     'autoconf',
     'ssh',
     'gnupg2', 'scdaemon', 'pcscd',
     'vim-gtk', 'emacs24',
     'chromium-browser',
     'ruby',
     'python3',
     'python-gpgme',
     'dropbox',
     'rxvt-unicode',
     'zsh',
     'tmux',
     'texlive',
     'texlive-latex-extra',
     'texlive-xetex',
     'texlive-science',
     'texinfo',
     'latexmk',
     'curl',
     'cifs-utils',
     'winbind',
     'xscreensaver',
     'skype',
     'workrave']:
       ensure => installed;
  }

  # Required for rvm rubies on Ubuntu
  package {
    ['gawk', 'libreadline6-dev', 'zlib1g-dev', 'libssl-dev', 'libyaml-dev', 'libsqlite3-dev', 'sqlite3', 'libgdbm-dev', 'libncurses5-dev', 'libtool', 'bison', 'pkg-config', 'libffi-dev']:
      ensure => installed;
  }

  Package['python-gpgme'] -> Package['dropbox']

  vcsrepo { "/home/$box_username/.dotfiles":
    ensure => present,
    provider => git,
    source => 'git@github.com:jezcope/dotfiles.git',
    require => Package['git'],
    user => $box_username,
  }

  exec { 'fetch Input font':
    command => 'wget -O /opt/Input-Font.zip "http://input.fontbureau.com/build/?customize&fontSelection=whole&a=ss&g=ss&i=serifs&l=0&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email="',
    path => '/usr/bin',
    creates => '/opt/Input-Font.zip',
  }

}
