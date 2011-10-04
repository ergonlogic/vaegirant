# A Puppet manifest to provision An Aegir Hostlave server
# Ref.: http://community.aegirproject.org/node/30

import "base.pp"

file { '/etc/motd':
  content => "Welcome to (one of) your Aegir Hostslave virtual machine(s)!
              Built by Vagrant. Managed by Puppet.\n"
}

# dependencies
package { 'debconf-utils': ensure => present, }
package { 'apache2' : ensure => present, }
package { 'php5-cli' : ensure => present, }
package { 'php5-mysql' : ensure => present, }
package { 'postfix' : ensure => present, }
package { 'mysql-client' : ensure => present, }
package { 'mysql-server' :
  ensure => present,
  responsefile => '/tmp/vagrant-puppet/manifests/files/mysql-server.preseed',
}

# 'aegir' user
group { "aegir" : ensure => present, }
user { "aegir":
  ensure => present,
  comment => "Aegir system user, added by Puppet",
  gid => "aegir",
  groups => ['www-data'],
  shell => "/bin/bash",
  home => "/var/aegir",
  managehome => true,
}
exec { 'sudoers' :
  command => "/bin/echo 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' >> /etc/sudoers",
  unless => "/bin/grep -qFx 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' '/etc/sudoers'",
  require => User['aegir'],
}

# apache config
exec { 'a2enmod' :
  command => '/usr/sbin/a2enmod rewrite',
  require => Package['apache2'],
}
file {'/etc/apache2/conf.d/aegir.conf' :
  target => '/var/aegir/config/apache.conf',
  require => Exec['a2enmod'],
  ensure => link,
}

# MySQL config
service { "mysqld":
  ensure => running,
  require => Package["mysql-server"],
}
exec { "grant-all-privileges":
  command => "/usr/bin/mysql -uroot -pPASSWORD -e \"GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY PASSWORD;\"",
  require => Service["mysqld"],
}
exec { "flush-privileges":
  command => "/usr/bin/mysql -uroot -e \"FLUSH PRIVILEGES;\"", 
  require => [
    Service["mysqld"],
    Exec["grant-all-privileges"],
  ],
}

# /var/aegir/.ssh/authorized_keys
