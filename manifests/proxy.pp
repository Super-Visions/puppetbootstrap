class puppetbootstrap::proxy ( $host, $port = 80, $proto = 'http', $user = undef, $pass = undef, $ensure = 'present', $noproxy = undef ) {

  file { '/etc/profile.d/proxy.sh':
    ensure  => $ensure,
    content => "export http_proxy=${proto}://${host}:${port}\nexport https_proxy=${proto}://${host}:${port}\nexport no_proxy=${noproxy}",
  }

  if $ensure == 'present' {
    $proxy_action = 'export'
  } else {
    $proxy_action = 'unset'
  }
  exec { "${proxy_action} http_proxy=${proto}://${host}:${port}": 
    provider => shell,
  }
  exec { "${proxy_action} https_proxy=${proto}://${host}:${port}":
    provider => shell,
  }

  # export export no_proxy=.mobistar.be
  if $noproxy {
    $noproxy_action = 'export'
  } else {
    $noproxy_action = 'unset'
  }
  exec { "${noproxy_action} no_proxy=${noproxy}": 
    provider => shell,
  }

}
