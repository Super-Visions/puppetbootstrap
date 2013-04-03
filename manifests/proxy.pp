class puppetbootstrap::proxy ( $host, $port = 80, $user = undef, $pass = undef ) {
  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    content => "export http_proxy=http://${host}:${port}",
  }
  file { '/etc/yum.conf':
    ensure => present,
    source => 'puppet:///modules/puppetbootstrap/yum.conf',
  }
}
