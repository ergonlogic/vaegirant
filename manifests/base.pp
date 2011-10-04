# An example Puppet manifest to provision the message of the day:

group { 'puppet': ensure => present, }

File { owner => 0, group => 0, mode => 0644 }

package { 'git': ensure => present, }
package { 'vim': ensure => present, }
package { 'htop': ensure => present, }
