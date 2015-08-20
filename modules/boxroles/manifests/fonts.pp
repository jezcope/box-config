class boxroles::fonts {

  apt::source { 'multiverse':
    location => 'http://archive.ubuntu.com/ubuntu',
    repos => 'multiverse',
  }

  package {
    [
     'unzip',
     'fonts-texgyre', 'fonts-crosextra-caladea', 'fonts-crosextra-carlito',
     'ttf-mscorefonts-installer',
     ]:
       ensure => present;
  }

  exec { 'accept mscorefonts license':
    command => 'echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" | debconf-set-selections',
    provider => shell,
    unless => "debconf-get-selections|grep -E 'msttcorefonts/accepted-mscorefonts-eula.*true' > /dev/null",
    before => Package['ttf-mscorefonts-installer'];
  }

  exec {
    default:
      path => '/bin:/usr/bin';
    'fetch Input font':
      command => 'wget -O /opt/Input-Font.zip "http://input.fontbureau.com/build/?customize&fontSelection=whole&a=ss&g=ss&i=serifs&l=0&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email="',
      creates => '/opt/Input-Font.zip';
    'fetch Goudy Bookletter 1911 font':
      command => 'wget -O /opt/Goudy-Bookletter-1911.zip "http://www.fontsquirrel.com/fonts/download/Goudy-Bookletter-1911"',
      creates => '/opt/Goudy-Bookletter-1911.zip';
    'extract Input font':
      command => 'unzip /opt/Input-Font.zip -d /usr/share/fonts/opentype Input_Fonts/\*',
      creates => '/usr/share/fonts/opentype/Input_Fonts',
      subscribe => Exec['fetch Goudy Bookletter 1911 font'],
      require => Package['unzip'],
      notify => Exec['update font cache'];
    'extract Goudy Bookletter 1911 font':
      command => 'unzip /opt/Goudy-Bookletter-1911.zip -d /usr/share/fonts/opentype goudy_bookletter_1911.otf',
      creates => '/usr/share/fonts/opentype/goudy_bookletter_1911.otf',
      subscribe => Exec['fetch Goudy Bookletter 1911 font'],
      require => Package['unzip'],
      notify => Exec['update font cache'];
    'update font cache':
      command => 'fc-cache -s',
      refreshonly => true;
  }
}
