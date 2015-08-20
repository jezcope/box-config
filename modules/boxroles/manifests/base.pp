class boxroles::base {

  include apt
  include boxutils::dotfiles
  include boxroles::fonts

  user { $box_username:
    ensure => present,
  }

  file { $box_homedir:
    ensure => directory,
    owner => $box_username,
    group => $box_usergrp,
  }

  package {
    ['ldap-utils',
     'aptitude', 'git', 'bzr', 'mercurial', 'cvs', 'puppet-lint',
     'build-essential',
     'autoconf',
     'ssh', 'lftp',
     'ack-grep', 'silversearcher-ag',
     'gnupg2', 'scdaemon', 'pcscd', 'libpcsclite-dev',
     'keychain',
     'offlineimap',
     'ruby',
     'python3',
     'python-pip',
     'ipython', 'ipython-notebook', 'ipython3', 'ipython3-notebook',
     'libgmime-2.6-dev', 'libxapian-dev', 'html2text', # for mu4e
     'pandoc',
     'zsh',
     'tmux',
     'maildir-utils',
     'texlive',
     'texlive-latex-extra',
     'texlive-xetex',
     'texlive-science',
     'texinfo',
     'latexmk',
     'curl',
     'cifs-utils',
     'winbind',
     ]:
       ensure => present;
  }

  # Required for rvm rubies on Ubuntu
  package {
    ['gawk', 'libreadline6-dev', 'zlib1g-dev', 'libssl-dev', 'libyaml-dev', 'libsqlite3-dev', 'sqlite3', 'libgdbm-dev', 'libncurses5-dev', 'libtool', 'bison', 'pkg-config', 'libffi-dev']:
      ensure => installed;
  }

  file { '/usr/lib/libpcsclite.so':
    ensure => link,
    target => '/usr/lib/x86_64-linux-gnu/libpcsclite.so',
    require => Package['libpcsclite-dev'];
  }

}

