$dirs = ['/home/dummy/foo/bar','/home/dummy/foo/baz']
file { '/home/dummy':
  ensure => directory
}
$dirs.each |$dir| {
  $splitdirs = dirtree($dirs, '/home/dummy')
  # $splitdirs.each |$sdir| {
  ensure_resource('file', $splitdirs, {'ensure' => 'directory'})
    # file { $sdir:
    #   ensure => directory
    # }
  # }
}
