node 'default' {
  $user = 'dummy'
  $home_directory = "/home/${user}"
  $user_directories = ['/home/dummy/foo', 'bar', 'baz/tar', 'baz/qux']

  class { 'casestudy':
    user             => $user,
    user_directories => $user_directories,
    home_directory   => $home_directory
  }
}
