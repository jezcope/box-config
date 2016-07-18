class boxroles::webdev {

  $p = hiera('packages')

  package { [$p['mysql'],
             'npm',
             'ruby-haml',
             'hugo']: }

}
