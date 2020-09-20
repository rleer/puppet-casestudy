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
