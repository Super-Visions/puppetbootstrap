class puppetbootstrap::proxy (
  $host,
  $port = 80,
  $proto = 'http',
  $user = undef,
  $pass = undef,
  $ensure = 'present',
  $noproxy = undef
) {

  file { '/etc/profile.d/proxy.sh':
    ensure  => $ensure,
    content => "export http_proxy=${proto}://${host}:${port}\nexport https_proxy=${proto}://${host}:${port}\nexport no_proxy=${noproxy}",
  }

  if $ensure == 'present' {
    # $proxy_action = 'export'
    # $augeas_action = 'set'
    # exec { "${proxy_action} http_proxy=${proto}://${host}:${port}":
    #   provider => shell,
    # }
    # exec { "${proxy_action} https_proxy=${proto}://${host}:${port}":
    #   provider => shell,
    # }
  } else {
    $proxy_action = 'unset'
    $augeas_action = 'rm'
    exec { "/usr/bin/git config --global --unset http.proxy":
      provider => shell,
    }
    exec { "/usr/bin/git config --global --unset https.proxy":
      provider => shell,
    }
  }
  
  augeas { "gitproxy":
    context => "/files/home/git/.gitconfig/http",
    changes => [
      "${augeas_action} proxy '${proto}://${host}:${port}'",
    ],
  }



  # export export no_proxy=.mobistar.be
  if $noproxy {
    # $noproxy_action = 'export'
    # exec { "${noproxy_action} no_proxy=${noproxy}":
    #   provider => shell,
    # }
  } else {
    $noproxy_action = 'unset'
  }

  augeas { "proxyenv" :
    context => "/files/etc/environment",
    changes => [
      "set http_proxy '${proto}://${host}:${port}'",
      "set https_proxy '${proto}://${host}:${port}'",
      "set no_proxy '${noproxy}'",
    ],
  }

}
