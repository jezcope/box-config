node default {

  $box_username = jez
  $box_usergrp = $box_username
  $box_homedir = "/home/$box_username"

  include boxroles::base
  include boxutils::dotfiles
  include boxroles::graphical

  class { 'apt':
    update => {
      frequency => daily,
    },
  }

}
