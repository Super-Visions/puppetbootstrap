class puppetbootstrap::proxy ( $host, $port = 80, $user = undef, $pass = undef ) {

  file { '/etc/profile.d/proxy.sh':
    ensure  => present,
    content => "export http_proxy=http://${host}:${port}\nexport https_proxy=http://${host}:${port}",
  }
  file { '/etc/yum.conf':
    ensure  => present,
    content => template("puppetbootstrap/yum.conf.erb"),
    #source  => 'puppet:///modules/puppetbootstrap/yum.conf',
  }
  exec { "export http_proxy=http://${host}:${port}": 
    provider => shell,
  }
  exec { "export https_proxy=http://${host}:${port}":
    provider => shell,
  }

}
