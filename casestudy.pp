$user = 'dummy'
$home_directory = "/home/${user}"
$user_directories = ['/home/dummy/foo', 'bar', 'baz/tar', 'baz/qux']

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
      $sub_paths = dirtree($directory, $home_directory)
      ensure_resource('file', $sub_paths, {
        'ensure' => 'directory',
        'owner' => $::user,
        'group' => $::user})

      file { "${directory}/info.txt":
        ensure  => file,
        content => 'lul'
      }
    } else {
      # Join the current path with the home directory path
      $full_path = "${home_directory}/${directory}"
      $sub_paths = dirtree($full_path, $home_directory)
      ensure_resource('file', $sub_paths, {'ensure' => 'directory'})

      file { "${full_path}/info.txt":
        ensure  => file,
        content => 'lul'
      }
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

# Creates a 'info.txt' file in given path
define create_info_txt ($target_path = $name) {
  # Get the name of the parent directory
  $parent_dir = $target_path.match('[a-zA-Z]+$')
  $content = $parent_dir.join('')

  file { "${target_path}/info.txt":
    ensure  => file,
    content => "${content}\n",
    owner   => $::user,
    group   => $::user
  }
}

# Ensures that all directories in path are created
define create_dir_tree ($directory = $name) {
  # Generates all sub paths, e.g. ['/foo', '/foo/bar', '/foo/bar/baz']
  $sub_paths = dirtree($directory, $::home_directory)

  # Ensures that no duplicate resources are declared
  ensure_resource('file', $sub_paths, {
    'ensure' => 'directory',
    'owner'  => $::user,
    'group'  => $::user
    })
}
