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


# @summary
#   Populates the user's home directory from given list of directories. Each new 
#   directory contains a 'info.txt' file containing the target's directory name.
#   All other files and directories in the user's home directory that are not
#   managed by Puppet will be deleted.
#
# @example
#   class { 'casestudy':
#     user             => 'johndoe',
#     user_directories => ['foo', 'foo/bar'],
#     home_directory   => '/home/johndoe'
#   }
#
# @note
#   Directories can be specified as absolute path, e.g. '/home/user/target/dir' or
#   as a relative path to the home directory , e.g. 'target/dir'.
#   Duplicate paths are not allowed.
#
# @param user
#   Names the user id
# @param user_directories
#   Defines an array of directory paths that will be created
# @param home_directory
#   Defines the path to the given user's home directory
#
class casestudy(
  String $user,
  Array[String] $user_directories,
  String $home_directory = "/home/${user}"
) {
  if !empty($user_directories) {
    # Makes sure the user exists
    user { $user:
      ensure => present,
    }

    # Makes sure home directory exists and all files and directories not
    # managed by Puppet are deleted
    file { $home_directory:
      ensure  => directory,
      owner   => $user,
      group   => $user,
      recurse => true,
      purge   => true,
      force   => true
    }

    $user_directories.each |String $directory| {
      # Check if path starts with home directory path
      if $directory =~ Regexp("^${home_directory}") {

        casestudy::user_directory { $directory:
          exclusion_path => $home_directory,
          user_id        => $user
        }

        casestudy::infofile { $directory:
          user_id => $user
        }
      } else {
        # Join the current path with the home directory path
        $full_path = "${home_directory}/${directory}"

        casestudy::user_directory { $full_path:
          exclusion_path => $home_directory,
          user_id        => $user
        }

        casestudy::infofile { $full_path:
          user_id => $user
        }
      }
    }
  } else {
    notify { 'No user directories specified!': }
  }
}

# @summary
#   Creates a 'info.txt' file in a directory pointed to by a given path.
#   The file contains the target directory name.
#
# @example
#   casestudy::infofile { '/path/to/target/dir':
#     user_id => 'johndoe'
#   }
#
# @note
#   An absolut path as the target directory is expected.
#
# @param target_path
#   Defines the path to the target directory
# @param user_id
#   Names the user id
#
define casestudy::infofile (
  String $target_path = $name,
  String $user_id     = 'root'
) {
  # Get the name of the target directory, e.g. 'foo' in '/path/to/foo'
  $target_dir = $target_path.match('[a-zA-Z]+$')
  $content = $target_dir.join('')

  file { "${target_path}/info.txt":
    ensure  => file,
    content => "${content}\n",
    owner   => $user_id,
    group   => $user_id,
    require => File[$target_path]
  }
}

# @summary
#   Creates a directory at given location and ensures that all non-existent 
#   parent directories are created as well.
#
# @example
#   casestudy::user_directory { '/path/to/target/dir':
#     userid => 'johndoe'
#   }
#   The behaviour is similar to 'mkdir -p /path/to/target/dir'.
#
# @note
#   An absolut path as the target directory is expected.
#
# @param target_dir
#   Defines the target directory as an absolut path 
# @param exclusion_path
#   Defines a (sub-)path that does not need to be checked for existence
# @param user_id
#   Names the user id
#
define casestudy::user_directory (
  String $target_dir     = $name,
  String $exclusion_path = undef,
  String $user_id        = 'root'
) {
  # Generates all sub paths, e.g. ['/path', '/path/to', '/path/to/target']
  if empty($exclusion_path) {
    $sub_paths = dirtree($target_dir)
  } else {
    $sub_paths = dirtree($target_dir, $exclusion_path)
  }

  # Ensures that no duplicate directories are created
  ensure_resource('file', $sub_paths, {
    'ensure' => 'directory',
    'owner'  => $user_id,
    'group'  => $user_id
  })
}
