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
  
  package {
    ['aptitude', 'git', 'bzr', 'mercurial', 'cvs',
     'build-essential',
     'autoconf',
     'ssh',
     'gnupg2',
     'pcscd',
     'vim-gtk',
     'emacs24',
     'chromium-browser',
     'ruby',
     'python3',
     'python-gpgme',
     'dropbox',
     'zsh',
     'tmux',
     'texlive',
     'texlive-latex-extra',
     'texlive-science',
     'texinfo',
     'curl',
     'cifs-utils',
     'winbind']:
       ensure => installed;
  }

  Package['python-gpgme'] -> Package['dropbox']
}
