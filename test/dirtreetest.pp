
node 'default' {
  $user = 'dummy'
  $str = ['/home/dummy/foo', 'bar']

  class { 'casestudy':
    user => $user,
    hdir => "/home/${user}",
    dirs => $str
  }
}

#
class casestudy($user, $hdir, $dirs) {
  # class { 'user_check':
  #   user => $user,
  #   hdir => $hdir,
  # }
  notice($dirs)
  $dirs.each |String $dir| {
    if '/' in $dir {
      $arr = dirtree($dir, $hdir)
      notice($dir)
      notice($hdir)
      # file { $dir:
      #   ensure => directory
      # }
    } else {
      
      $fqpath = "${hdir}/${dir}"
      
    }
  }
  # else {

  #   file { $dirs:
  #       ensure => directory
  #   }
  # }
}

#
class user_check($user, $hdir) {
  user { $user:
    ensure => present
  }
  file { $hdir:
    ensure => directory
  }
}
