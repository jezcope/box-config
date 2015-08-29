class boxroles::base {

  include boxroles::minimal
  # include boxroles::fonts

  $p_ssh = hiera('packages.ssh', 'ssh')
  $p_xapian = hiera('packages.xapian', 'xapian')
  $p_ldap= hiera('packages.ldap-utils', 'ldap-utils')
  $p_silversearcher = hiera('packages.silversearcher', 'silversearcher-ag')
  $p_gmime = hiera('packages.gmime', 'gmime')
  $p_gdbm = hiera('packages.gdbm', 'gdbm')
  $p_python = hiera('packages.python', 'python')
  $p_pip = hiera('packages.pip', 'python-pip')
  $p_gnupg = hiera('packages.gnupg', 'gnupg')
  $p_tex = hiera('packages.tex')
  $p_cifs = hiera('packages.cifs', 'cifs-utils')

  package {
    [$p_ldap,
     'bzr', 'mercurial', 'cvs',
     # 'librarian-puppet', 'puppet-lint', TODO: install these as gems instead
     'autoconf',
     $p_ssh, 'lftp',
     'unison',
     'apg',
     $p_silversearcher,
     $p_gnupg,
     'keychain',
     'offlineimap',
     'imagemagick',
     'ruby',
     $p_python,
     $p_gmime, $p_xapian, 'html2text', # for mu4e
     # 'pandoc', TODO: install this from cabal instead
     $p_tex,
     'tmux',
     'curl', 'wget',
     $p_cifs,
     'qrencode',
     ]:
       ensure => present;
  }

  # Required for rvm rubies on Ubuntu
  package { hiera('packages.rvm-required', []):
      ensure => installed;
  }

  if ::osfamily == 'Debian' {
    file { '/usr/lib/libpcsclite.so':
        ensure => link,
        target => '/usr/lib/x86_64-linux-gnu/libpcsclite.so',
        require => Package['libpcsclite-dev'];
    }
  }

}

