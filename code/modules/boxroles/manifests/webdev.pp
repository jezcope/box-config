class boxroles::webdev {

  $p = hiera('packages')

  package { [$p['mysql'],
             'docker-engine',
             'nodejs', 'npm',
             'ruby-haml',
             'hugo']:
  }

  if $::osfamily == 'Debian' {
    include apt

    apt::source { 'docker':
      location => 'https://apt.dockerproject.org/repo',
      release => "${os[name]}-${os[distro][codename]}".downcase,
      repos => 'main',
      key => {
        id => '58118E89F3A912897C070ADBF76221572C52609D',
        server => 'hkp://p80.pool.sks-keyservers.net:80',
      },
    }

    package { ['docker.io', 'lxc-docker']:
      ensure => purged,
    }

    file { '/usr/bin/node':
      ensure => link,
      target => '/usr/bin/nodejs',
      require => Package['nodejs'],
    }
  }

}
