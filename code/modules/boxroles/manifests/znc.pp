class boxroles::znc {

  package {'znc':}

  group {'bouncer':
    ensure => present,
  }

  user {'bouncer':
   gid => 'bouncer',
   home => '/var/lib/bouncer',
   require => Group['bouncer'],
  }

  file {'/var/lib/bouncer':
    ensure => directory,
    owner => 'bouncer',
    group => 'bouncer',
    mode => '0700',
    require => User['bouncer'],
  }

  file {'/etc/systemd/system/znc.service':
    source => 'puppet:///modules/boxroles/znc.service',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
  
}
