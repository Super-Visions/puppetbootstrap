
# http://insight.fab-it.dk/2008/11/14/building-a-puppetmaster-with-puppet/

#include puppetbootstrap

# Install puppetmaster, apache2 and Phusion Passenger
# Set up the directories, configure apache and Passenger
# and ensure that the apache service is running
class puppetbootstrap::puppetbootstrap {

  #$rack_base_dir = '/etc/puppet'
  $rack_base_dir = '/etc/puppet-rack'

    Exec {
        path => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin'
    }

    if $::osfamily == 'RedHat' {
      $passenger = 'mod_passenger'
      package {
        [ 'httpd', 'mod_ssl', 'puppet-server', 'ruby', $passenger, 'rubygem-rack' ]:
        ensure => installed,
      }
    }
    else
    {
      $passenger = 'passenger'
      package {
        [ "httpd", "httpd-devel", "mod_ssl", "puppet-server", "rubygems", "ruby" ]:
          ensure  => latest;
        "libcurl-devel":
          ensure => installed;
        "rack":
          ensure    => "installed",
          provider  => "gem",
          require   => Package["rubygems"];
        $passenger:
          ensure    => "installed",
          provider  => "gem",
          require   => [ Package["rubygems"], Package["httpd"], Package["httpd-devel"], Package["ruby"]];
      }
      exec { 'yes | /usr/bin/passenger-install-apache2-module':
        require => Package[$passenger],
      }
    }

    #    file { '/etc/puppet/ssl':
    #  ensure => link,
    #  target => '/var/lib/puppet/ssl',
    #  require => Package['puppet-server'],
    #}

    file { ["${rack_base_dir}", "${rack_base_dir}/rack", "${rack_base_dir}/rack/public"]:
        ensure => directory,
        mode   => '0755',
        owner  => root,
        group  => root,
    }
    file { "${rack_base_dir}/rack/config.ru":
        ensure => present,
        source => 'puppet:///modules/puppetbootstrap/config.ru',
        mode   => '0644',
        owner  => puppet,
        group  => root,
    }

    $http_conf_content = template('puppetbootstrap/httpd.conf.erb')

    file { '/etc/httpd/conf.d/puppetmasterd.conf':
        ensure  => present,
        content => $http_conf_content,
        mode    => '0644',
        owner   => root,
        group   => root,
        require => [File["${rack_base_dir}/rack/config.ru"], File["${rack_base_dir}/rack/public"], Package['httpd'], Package[$passenger]],
        notify  => Service['httpd'],
    }
  
    exec { 'start and stop master':
      command => 'service puppetmaster start; service puppetmaster stop',
    }

    service { 'httpd':
        ensure    => 'running',
        enable    => true,
        hasstatus => false,
        require   => Exec['start and stop master'],
    }

    file { [ '/etc/facter', '/etc/facter/facts.d' ]:
        ensure => directory,
        mode   => '0755',
        owner  => root,
        group  => root,
    }

    file { [ '/var/lib/puppet', '/var/lib/puppet/reports']:
        ensure => directory,
        mode   => '0755',
        owner  => puppet,
        group  => puppet,
    }
}
