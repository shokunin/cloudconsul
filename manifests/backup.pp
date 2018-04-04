# install and configure snatch
class cloudconsul::backup inherits cloudconsul {

  file { '/usr/local/bin/consul-backup':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/consul-backup'
  }

  cron { 'consul-backup':
    command => '/usr/local/bin/consul-backup',
    user    => 'consul',
    hour    => '*',
    minute  => '2',
  }

}
