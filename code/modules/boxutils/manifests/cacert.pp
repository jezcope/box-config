class boxutils::cacert {

  file { '/usr/local/share/ca-certificates/cacert.org':
    ensure => directory;
  '/usr/local/share/ca-certificates/cacert.org/root.crt':
    source => 'puppet:///modules/boxutils/root.crt',
    notify => Exec['/usr/sbin/update-ca-certificates'];
  '/usr/local/share/ca-certificates/cacert.org/class3.crt':
    source => 'puppet:///modules/boxutils/class3.crt',
    notify => Exec['/usr/sbin/update-ca-certificates'];
  }

  exec { '/usr/sbin/update-ca-certificates':
    refreshonly => true,
  }

}
