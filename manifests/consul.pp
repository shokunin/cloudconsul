# install and configure consul
class cloudconsul::consul inherits cloudconsul {

  file { '/opt/consul':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { '/opt/consul/etc':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/opt/consul'],
  }

  class { '::consul':
    purge_config_dir => false,
    manage_service   => false,
    init_style       => 'unmanaged',
    notify           => Exec['consul_dont_start'],
    config_hash      => {
      'data_dir'  => '/opt/consul/data',
    }
  }

  exec { 'consul_dont_start':
    command     => '/bin/rm -rf /etc/init.d/consul /etc/init/consul.conf /etc/consul /lib/systemd/system/consul.service',
    refreshonly => true,
  }


  file { '/usr/local/bin/setup_consul_master':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/setup_consul_master',
  }

  # this will overwrite the base image so it runs as a server
  file { '/etc/supervisor.d/consul.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/cloudconsul/consul.conf',
    require => Class['consul', 'supervisor'],
    notify  => Exec['consul_dont_start'],
  }

  file { '/opt/consul/etc/role.json':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/cloudconsul/role.json',
    require => Class['consul'],
    notify  => Exec['consul_dont_start'],
  }

}
