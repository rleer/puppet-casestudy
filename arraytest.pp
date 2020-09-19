node 'default' {
  $array = ['/a', '/a/b', '/a/b/c', '/a/b/d/f', '/a/b/c/d/f/e/r/t']
  class { 'arraytestclass':
    input => $array
  }
}

#
class arraytestclass($input) {
  $dir = '/a/b'
  $reg = "^(?!(${dir}$).*$"
  # $data = $input.filter |$value| { $value =~ /\/.+\/.+\/.+$/}
  $data = $input.filter |$value| { $value =~ Regexp("${reg}")}
  notice($input)
  notify { $data:
  }
}
