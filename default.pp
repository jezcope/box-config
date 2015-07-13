node default {
  include apt

  apt::source { 'dropbox':
    location => 'http://linux.dropbox.com/ubuntu',
    repos => 'main',
    key => {
      id => '1C61A2656FB57B7E4DE0F4C1FC918B335044912E',
      server => 'pgp.mit.edu',
    },
    before => Package['dropbox'],
  }
  
  package { 'aptitude':
    ensure => installed,
  }

  package { 'git':
    ensure => installed,
  }

  package { 'ssh':
    ensure => installed,
  }

  package { 'gnupg2':
    ensure => installed,
  }

  package { 'pcscd':
    ensure => installed,
  }

  package { 'emacs24':
    ensure => installed,
  }

  package { 'chromium-browser':
    ensure => installed,
  }

  package { 'ruby':
    ensure => installed,
  }

  package { 'python3':
    ensure => installed,
  }

  package { 'dropbox':
    ensure => installed,
  }

}
