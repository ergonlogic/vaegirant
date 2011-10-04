# A Puppet manifest to provision an Aegir Hostmaster server

import "base.pp"

file { '/etc/motd':
  content => "Welcome to your Aegir Hostmaster virtual machine!
              Built by Vagrant. Managed by Puppet.\n"
}

# add Koumbit repo
file { '/etc/apt/sources.list.d/koumbit.list':
  source => "/vagrant/manifests/files/koumbit.list",
}
exec { 'get key':
  command => "/usr/bin/wget http://debian.koumbit.net/debian/key.asc",
  require => File['/etc/apt/sources.list.d/koumbit.list'],
}
exec { 'add key':
  command => "/usr/bin/apt-key add key.asc",
  require => Exec['get key'],
}
exec { 'apt-update':
  command => "/usr/bin/apt-get update",
  require => Exec['add key'],
}

# dependencies
package { 'debconf-utils': ensure => present, }
package { 'drush': ensure => '4.4-2~bpo60+1', }
package { 'mysql-server' :
  ensure => present,
  responsefile => '/tmp/vagrant-puppet/manifests/files/mysql-server.preseed',
}
package { 'aegir':
  ensure => present,
  responsefile => '/tmp/vagrant-puppet/manifests/files/aegir.preseed',
  require => [
    Package['debconf-utils'], 
    Package['mysql-server'],
    Package['drush'],
    Exec['apt-update'],
  ],
}


