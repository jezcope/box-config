class boxroles::scientific {

  if $::osfamily == "Debian" {
    include apt

    apt::source { 'r':
      location => 'https://mirrors.ebi.ac.uk/CRAN/bin/linux/ubuntu',
      release => "$lsbdistcodename/",
      repos => '',
    }

  }

  package { 'r-base': }

}
