class dotfiles {

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

node default {
  include apt

  $box_username = jez
  $box_usergrp = $box_username
  $box_homedir = "/home/$box_username"

  class { 'dotfiles': }

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
    ['aptitude', 'git', 'bzr', 'mercurial', 'cvs', 'puppet-lint',
     'build-essential',
     'autoconf',
     'ssh',
     'gnupg2', 'scdaemon', 'pcscd',
     'keychain',
     'vim-gtk', 'emacs24',
     'chromium-browser',
     'ruby',
     'python3',
     'python-gpgme',
     'python-pip',
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
     'ttf-mscorefonts-installer',
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

  exec { 'accept mscorefonts license':
    command => 'echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | debconf-set-selections',
    provider => shell,
    unless => "debconf-get-selections|grep -E 'msttcorefonts/accepted-mscorefonts-eula.*true' > /dev/null",
    before => Package['ttf-mscorefonts-installer'];
  }

  file { '/opt/lplinux':
    ensure => directory;
  }

  exec {
    default:
      path => '/bin:/usr/bin';
    'fetch Input font':
      command => 'wget -O /opt/Input-Font.zip "http://input.fontbureau.com/build/?customize&fontSelection=whole&a=ss&g=ss&i=serifs&l=0&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email="',
      creates => '/opt/Input-Font.zip';
    'fetch Goudy Bookletter 1911 font':
      command => 'wget -O /opt/Goudy-Bookletter-1911.zip "http://www.fontsquirrel.com/fonts/download/Goudy-Bookletter-1911"',
      creates => '/opt/Goudy-Bookletter-1911.zip';
    'extract Input font':
      command => 'unzip /opt/Input-Font.zip -d /usr/share/fonts/opentype Input_Fonts/\*',
      creates => '/usr/share/fonts/opentype/Input_Fonts',
      subscribe => Exec['fetch Goudy Bookletter 1911 font'],
      notify => Exec['update font cache'];
    'extract Goudy Bookletter 1911 font':
      command => 'unzip /opt/Goudy-Bookletter-1911.zip -d /usr/share/fonts/opentype goudy_bookletter_1911.otf',
      creates => '/usr/share/fonts/opentype/goudy_bookletter_1911.otf',
      subscribe => Exec['fetch Goudy Bookletter 1911 font'],
      notify => Exec['update font cache'];
    'update font cache':
      command => 'fc-cache -s';
    'fetch lastpass binary bundle':
      command => 'wget -O /opt/lplinux.tar.bz2 "https://lastpass.com/lplinux.tar.bz2"',
      creates => '/opt/lplinux.tar.bz2';
    'extract lastpass binary bundle':
      command => 'tar -xf /opt/lplinux.tar.bz2 -C /opt/lplinux',
      creates => '/opt/lplinux/install_lastpass.sh',
      require => [File['/opt/lplinux'], Exec['fetch lastpass binary bundle']],
      before => Exec['install lastpass binary bundle'];
    'install lastpass binary bundle':
      command => '/opt/lplinux/install_lastpass.sh',
      user => $box_username,
      creates => '/etc/chromium/native-messaging-hosts/',
      require => Exec['extract lastpass binary bundle'];
  }

}
