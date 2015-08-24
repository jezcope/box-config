class boxroles::graphical {

  include apt

  apt::source { 'partner':
    location => 'http://archive.canonical.com/',
    repos => 'partner',
  }

  apt::source { 'mopidy':
    location => 'http://apt.mopidy.com/',
    release => 'stable',
    repos => 'main contrib non-free',
    key => {
      id => '9E36464A7C030945EEB7632878FD980E271D2943',
      source => 'https://apt.mopidy.com/mopidy.gpg',
    },
  }

  apt::source { 'dropbox':
    location => 'http://linux.dropbox.com/ubuntu',
    repos => 'main',
    key => {
      id => '1C61A2656FB57B7E4DE0F4C1FC918B335044912E',
      server => 'pgp.mit.edu',
    },
  }

  package {
    ['xscreensaver', 'xscreensaver-gl', 'xscreensaver-gl-extra',
     'emacs24-lucid', 'vim-gtk',
     'unison-gtk',
     'skype', 'pidgin',
     'mopidy', 'mopidy-spotify', 'ncmpcpp', 'mpc',
     'chromium-browser', 'firefox',
     'pavucontrol',
     'yubikey-personalization', 'yubikey-personalization-gui',
     'libreoffice-gtk', 'libreoffice-calc', 'libreoffice-writer', 'libreoffice-impress', 'libreoffice-draw',
     'abiword',
     'dropbox', 'python-gpgme',
     'workrave',
     'rxvt-unicode',
     'font-manager',
     ]:
      ensure => present;
  }

  Package['python-gpgme'] -> Package['dropbox']

  file { '/opt/lplinux':
    ensure => directory;
  }

  exec {
    default:
      path => '/bin:/usr/bin';
    'fetch lastpass binary bundle':
      command => 'wget -O /opt/lplinux.tar.bz2 "https://lastpass.com/lplinux.tar.bz2"',
      creates => '/opt/lplinux.tar.bz2';
    'extract lastpass binary bundle':
      command => 'tar -xf /opt/lplinux.tar.bz2 -C /opt/lplinux',
      creates => '/opt/lplinux/install_lastpass.sh',
      require => [Package['unzip'], File['/opt/lplinux'], Exec['fetch lastpass binary bundle']],
      before => Exec['install lastpass binary bundle'];
    'install lastpass binary bundle':
      command => '/opt/lplinux/install_lastpass.sh',
      user => $box_username,
      creates => "$box_homedir/.config/chromium/NativeMessagingHosts/",
      require => Exec['extract lastpass binary bundle'];
  }

}

