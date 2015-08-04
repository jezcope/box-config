class boxroles::graphical {

  apt::source { 'partner':
    location => 'http://archive.canonical.com/',
    repos => 'partner',
    before => Package['skype'],
  }

  apt::source { 'mopidy':
    location => 'http://apt.mopidy.com/',
    release => 'stable',
    repos => 'main contrib non-free',
    before => [Package['mopidy'], Package['mopidy-spotify']],
    key => {
      id => '9E36464A7C030945EEB7632878FD980E271D2943',
      source => 'https://apt.mopidy.com/mopidy.gpg',
    },
  }

  package {
    ['xscreensaver', 'xscreensaver-gl', 'xscreensaver-gl-extra',
     'skype', 'pidgin',
     'mopidy', 'mopidy-spotify', 'ncmpcpp', 'mpc',
     ]:
      ensure => present;
  }

}

