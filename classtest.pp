$arr = ['a', 'b']
$user = 'dummy'

# Class: test
# class test($dirs) {
#   $dirs.each |String $dir| {
#     file {""}
#   }
# }

# does create directory: [a,b]
class test(Array $input, String $uss) {
  # $data1 = $input.map |$param| { "/home/rid/code/puppet/puppet-casestudy/${param}" }
  $data1 = regsubst($input, '^', '/home/rid/code/puppet/puppet-casestudy/')
  $paths = dirtree('/home/rid/foo')
  notify { $uss:
  }

  # $input.each |String $dir| {
  #   notify { $dir:
  #     message => "each ${dir}"
  #   }
  # }
  notify { $input:
  }

  notify { $data1:
  }

  notify { $paths:
  }
  # file { $input:
  #   ensure => 'directory',
  # }
}

class { 'test':
  input => ['foo', 'bar'],
  uss   => $user
}

class { 'test':
  input => ['goo', 'laa'],
  uss   => $user
}
