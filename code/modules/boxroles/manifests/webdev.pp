class boxroles::webdev {

  $p = hiera('packages')

  package { [$p['mysql'], 'nodejs', 'npm', 'ruby-haml', 'hugo']:
  }

  if $::osfamily == 'Debian' {
    file { '/usr/bin/node':
      ensure => link,
      target => '/usr/bin/nodejs',
      require => Package['nodejs'],
    }
  }

}
