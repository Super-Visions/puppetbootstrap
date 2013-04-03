class puppetbootstrap::repo {
  
  file{'/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6':
    ensure => present,
    source => 'puppet:///modules/puppetbootstrap/RPM-GPG-KEY-EPEL-6',
  }

  file{'/etc/yum.repos.d/epel.repo':
    ensure => present,
    source => 'puppet:///modules/puppetbootstrap/epel.repo',
  }

  file{'/etc/yum.repos.d/puppetlabs.repo':
    ensure => present,
    source => 'puppet:///modules/puppetbootstrap/puppetlabs.repo',
  }

}
