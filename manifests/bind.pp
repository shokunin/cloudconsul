# install and configure bind9
class cloudconsul::bind inherits cloudconsul {

  package { 'bind9':
    ensure => installed,
  }

  package { 'jinja2':
    ensure   => installed,
    provider => pip,
  }

  service { 'bind9':
    ensure => stopped,
    enable => false,
  }

  file { '/usr/local/bin/setup_dns_zone':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/setup_dns_zone'
  }

  file { '/etc/supervisor.d/bind9.conf':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/cloudconsul/supervisord_bind'
  }

  file { '/usr/local/bin/bind_exporter':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/bind_exporter'
  }


}
