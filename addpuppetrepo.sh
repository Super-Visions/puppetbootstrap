#!/bin/bash

cat > /etc/yum.repos.d/puppetlabs.repo << EOM
[puppetlabs]
name=puppetlabs
baseurl=http://yum.puppetlabs.com/el/\$releasever/products/\$basearch
enabled=1
gpgcheck=0

[puppetlabs-deps]
name=puppetlabs dependencies
baseurl=http://yum.puppetlabs.com/el/\$releasever/dependencies/\$basearch
enabled=1
gpgcheck=0
EOM

