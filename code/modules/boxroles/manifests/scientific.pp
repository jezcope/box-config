class boxroles::scientific {

  # if $::osfamily == "Debian" {
  #   include apt

  #   apt::source { 'r':
  #     location => 'http://cran.r-project.org/bin/linux/ubuntu',
  #   }

  # }

  package { 'r-base': }

}
