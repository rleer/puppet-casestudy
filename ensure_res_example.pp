user { 'dummy':
  ensure => present,
}

ensure_resource('user', 'dummy', {'ensure' => 'present' })
