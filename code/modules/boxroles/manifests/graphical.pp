class boxroles::graphical {

  if $::osfamily == "Debian" {
    include apt


    if $::os[name] == "Ubuntu" {
        apt::source { 'partner':
            location => 'http://archive.canonical.com/',
            repos => 'partner',
        }
    }
    else {
        file { '/etc/apt/sources.list.d/partner.list':
            ensure => absent,
            notify => Exec['apt_update'],
        }
    }

    apt::source { 'dropbox':
        location => "http://linux.dropbox.com/${downcase($::os[name])}",
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
    [$p[emacs], $p[gvim],
     $p[mu4e],
     $p[unison-gtk],
     'skype', 'pidgin',
     $p[chromium],
     'firefox',
     'pavucontrol', $p[xbacklight],
     'xclip',
     'yubikey-personalization', 'yubikey-personalization-gui',
     $p[libreoffice],
     'abiword',
     $p[dropbox],
     'workrave',
     'sakura',
     'claws-mail',
     'caja', 'atril',
     'hexchat',
     'linssid',
     'filezilla',
     $p[pdf-tools-prerequisites],
     ]:
      ensure => present;
  }

}

