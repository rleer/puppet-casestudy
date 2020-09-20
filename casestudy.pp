$user = 'dummy'
$home_directory = "/home/${user}"
$user_directories = ['/home/dummy/foo', 'bar', 'baz/tar', 'baz/qux']
# $user_directories = ['/home/dummy/foo', '/home/dummy/foo']


if !empty($user_directories) {
  # Make sure user exists
  user { $user:
    ensure => present,
  }

  # Make sure home directory exists 
  file { $home_directory:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true
  }
}

$user_directories.each |String $directory| {
  if '/' in $directory {
    # Check if path starts with home directory path
    if $home_directory in $directory {
      create_dir_tree { $directory: }
      create_info_txt { $directory: }
    } else {
      # Join the current path with the home directory path
      $full_path = "${home_directory}/${directory}"

      create_dir_tree { $full_path: }
      create_info_txt { $full_path: }
      # $sub_paths = dirtree($full_path, $home_directory)
      # ensure_resource('file', $sub_paths, {'ensure' => 'directory'})

      # file { "${full_path}/info.txt":
      #   ensure  => file,
      #   content => 'lul'
      # }
    }
  } else {
    # Join the path with the home directory path
    $full_path = "${home_directory}/${directory}"
    ensure_resource('file', $full_path, {'ensure' => 'directory'})

    file { "${full_path}/info.txt":
      ensure  => file,
      content => 'lul'
    }
  }
}

# Creates a 'info.txt' file in given target directory 
define create_info_txt ($target_path = $name) {
  # Get the name of the target directory
  $target_dir = $target_path.match('[a-zA-Z]+$')
  $content = $target_dir.join('')

  file { "${target_path}/info.txt":
    ensure  => file,
    content => "${content}\n",
    owner   => $::user,
    group   => $::user,
    require => File[$target_path]
  }
}

# Creates target directory and makes sure that all parent directories are 
# created as well
define create_dir_tree ($directory = $name) {
  # Generates all sub paths, e.g. ['/foo', '/foo/bar', '/foo/bar/baz']
  $sub_paths = dirtree($directory, $::home_directory)

  # Ensures that no duplicate directories are created
  ensure_resource('file', $sub_paths, {
    'ensure' => 'directory',
    'owner'  => $::user,
    'group'  => $::user
    })
}
