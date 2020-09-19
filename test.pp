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
notice($path)
