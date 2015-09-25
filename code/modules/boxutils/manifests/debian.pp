class boxutils::debian {

  include apt

  include boxutils::cacert

  Apt::Source<| |> ~> Exec['apt_update']
  Apt::Ppa<| |> ~> Exec['apt_update']
  Exec['apt_update'] -> Package<| |>

  if $::lsbdistid == 'Ubuntu' and $::architecture == 'amd64' {
    exec { 'enable Ubuntu multiarch':
      command => '/usr/bin/dpkg --add-architecture i386',
      unless => '/usr/bin/dpkg --print-foreign-architectures | /bin/grep i386 > /dev/null',
      notify => Exec['apt_update'],
    }
  }

  package {
    ['aptitude', 'build-essential']:
    ensure => present;
  }

}
