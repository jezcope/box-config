class boxroles::scientific {

  if $::osfamily == "Debian" {
    include apt

    apt::source { 'r':
      location => 'https://mirrors.ebi.ac.uk/CRAN/bin/linux/ubuntu',
      release => "$lsbdistcodename/",
      repos => '',
      key => {
        id => 'E298A3A825C0D65DFD57CBB651716619E084DAB9',
        server => 'hkp://keyserver.ubuntu.com:80',
      },
    }

  }

  package { ['r-base', 'r-base-dev']: }

}
