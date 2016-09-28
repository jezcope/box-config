class boxroles::scientific {

  if $::os[name] == "Ubuntu" {
    include apt

    apt::source { 'r':
      location => 'https://cran.r-project.org/bin/linux/ubuntu',
      release => "$lsbdistcodename/",
      repos => '',
      key => {
        id => 'E298A3A825C0D65DFD57CBB651716619E084DAB9',
        server => 'hkp://keyserver.ubuntu.com:80',
      },
    }

  } else {
    file { '/etc/apt/sources.list.d/r.list':
      ensure => absent,
    }
  }

  $p = hiera('packages')

  package { [$p['r'], 'julia']: }

}
