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
class casestudy (
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
