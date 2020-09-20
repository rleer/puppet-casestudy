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
#   Expects an absolut path as the target directory.
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
