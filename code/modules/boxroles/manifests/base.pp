class boxroles::base {

  include boxroles::minimal
  # include boxroles::fonts

  $p = hiera('packages')

  package {
    [$p['ldap'],
     'bzr', 'mercurial', 'cvs',
     # 'librarian-puppet', 'puppet-lint', TODO: install these as gems instead
     'autoconf',
     $p['ssh'], 'lftp',
     'unison',
     'apg',
     $p['silversearcher'],
     $p['gnupg'],
     'keychain',
     'offlineimap',
     'imagemagick',
     'ruby',
     $p['python'],
     $p['gmime'], $p['xapian'], # for mu4e
     # 'pandoc', TODO: install this from cabal instead
     $p['tex'],
     'tmux',
     'curl', 'wget', 'unzip',
     $p['cifs'],
     'qrencode',
     $p['rvm-required'],
     ]:
       ensure => present;
     
     # ['librarian-puppet', 'puppet-lint']:
     #   ensure => present,
     #   provider => gem;
  }

  if ::osfamily == 'Debian' {
    file { '/usr/lib/libpcsclite.so':
        ensure => link,
        target => '/usr/lib/x86_64-linux-gnu/libpcsclite.so',
        require => Package['libpcsclite-dev'];
    }
  }

}

