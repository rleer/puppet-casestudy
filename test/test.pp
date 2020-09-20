# $str = '/foo'
# $arr = dirtree($str, '/home/rid')
# notice($arr)

# define testdef ($param = $name) {
#   notify { $param:
#   }
# }

# testdef { 'lul': }

# testdef { 'lol': }

# $path1 = '/home/dummy/foo'
# $parent_dir = $path1.match('[a-zA-Z]+$')
# $content = $parent_dir.join('')
# # file { '/home/dummy/test.txt':
# #   ensure  => file,
# #   content => $content
# # }
# notice($parent_dir)
# $exclusion_path = '/home/rid'
# $exclusion_path = ' '
# if '/home/rid/foo' =~ Regexp("^${homedir}") {
# # if '/home/rid/foo' =~ /^${homedir}/ {
#   notice('match')
# }

define testt (
  $some_dir       = $name,
  $exclusion_path = undef
){
  if empty($exclusion_path) {
    $sub_paths = dirtree($some_dir)
  } else {
    $sub_paths = dirtree($some_dir, $exclusion_path)
  }
  notice($sub_paths)
}

testt { '/home/rid/foo/bar': }
testt { '/home/rid/foo/baz':
  exclusion_path => '/home/rid'
}

#
# class testmulticlass (
#   $some_dir       = '/home/rid/foo/bar',
#   $exclusion_path = undef
# ){
#   if empty($exclusion_path) {
#     $sub_paths = dirtree($some_dir)
#   } else {
#     $sub_paths = dirtree($some_dir, $exclusion_path)
#   }
#   notice($sub_paths)
# }

# include 'testmulticlass'

# class { 'testmulticlass':
#   name => '/home/rid/foo/baz'
# }
