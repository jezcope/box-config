class boxroles::base {

  include boxroles::minimal
  # include boxroles::fonts

  $p = hiera('packages')

  package {
    [$p['ldap'],
     $p['gnutls'],
     'bzr', 'mercurial', 'cvs',
     # 'librarian-puppet', 'puppet-lint', TODO: install these as gems instead
     'autoconf',
     $p['ssh'], 'lftp', 'whois',
     'irssi', 'weechat',
     'colordiff', 'wdiff',
     'unison',
     'apg',
     $p['silversearcher'],
     $p['gnupg'],
     'keychain',
     'offlineimap',
     'imagemagick',
     'rlwrap',
     'ruby',
     $p['python'],
     'sbcl',
     $p['gmime'], $p['xapian'], # for mu4e
     # 'pandoc', TODO: install this from cabal instead
     $p['tex'],
     'tmux',
     'curl', 'wget', 'unzip',
     $p['cifs'], $p['exfat'],
     'qrencode',
     $p['rvm-required'],
     'shellcheck',
     ]:
       ensure => present;
     
     # ['librarian-puppet', 'puppet-lint']:
     #   ensure => present,
     #   provider => gem;
  }

  if $::osfamily == 'Debian' {
    file { '/usr/lib/libpcsclite.so':
        ensure => link,
        target => '/usr/lib/x86_64-linux-gnu/libpcsclite.so',
        require => Package['libpcsclite-dev'];
    }

    exec { 'fetch pandoc':
      path => '/usr/bin',
      command => 'wget -O  /opt/pandoc-1.15.0.6-1-amd64.deb "https://github.com/jgm/pandoc/releases/download/1.15.0.6/pandoc-1.15.0.6-1-amd64.deb"',
      creates => '/opt/pandoc-1.15.0.6-1-amd64.deb',
      require => Package['wget'];
    }

    package { 'pandoc':
      source => '/opt/pandoc-1.15.0.6-1-amd64.deb',
      provider => dpkg,
      require => Exec['fetch pandoc'],
    }
  }

}

