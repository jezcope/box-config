class boxroles::graphical {

  if $::osfamily == "Debian" {
    include apt

    apt::source { 'partner':
        location => 'http://archive.canonical.com/',
        repos => 'partner',
    }

    apt::source { 'dropbox':
        location => 'http://linux.dropbox.com/ubuntu',
        repos => 'main',
        key => {
        id => '1C61A2656FB57B7E4DE0F4C1FC918B335044912E',
        server => 'pgp.mit.edu',
        },
    }

    Package['python-gpgme'] -> Package['dropbox']

  }
  elsif $::osfamily == "Archlinux" {
    Exec['enable arch multilib'] -> Package['skype']
  }

  $p = hiera('packages')

  package {
    [$p[xscreensaver],
     $p[emacs], $p[gvim],
     $p[unison-gtk],
     'skype', 'pidgin',
     $p[chromium],
     'firefox',
     'pavucontrol', 'xbacklight',
     'yubikey-personalization', 'yubikey-personalization-gui',
     $p[libreoffice],
     'abiword',
     $p[dropbox],
     'workrave',
     'sakura',
     'claws-mail',
     ]:
      ensure => present;
  }

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

