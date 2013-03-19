#!/bin/bash

#cat > /etc/yum.repos.d/puppetlabs.repo << EOM
#[puppetlabs]
#name=puppetlabs
#baseurl=http://yum.puppetlabs.com/el/6/products/\$basearch
#enabled=1
#gpgcheck=0
#
#[puppetlabs-deps]
#name=puppetlabs dependencies
#baseurl=http://yum.puppetlabs.com/el/6/dependencies/\$basearch
#enabled=1
#gpgcheck=0
#EOM

#cat > /etc/yum.repos.d/foreman.repo << EOM
#[foreman]
#name=foreman
#baseurl=http://yum.theforeman.org/releases/1.0/el6/\$basearch
#enabled=1
#gpgcheck=0
#
#[foreman-source]
#name=foreman-source
#baseurl=http://yum.theforeman.org/releases/1.0/el6/source
#enabled=0
#gpgcheck=0
#EOM

puppet apply --debug --verbose --modulepath ../ manifests/puppetbootstrap3.pp -e "include puppetbootstrap3::puppetbootstrap"


