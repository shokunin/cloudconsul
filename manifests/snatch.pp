# install and configure snatch
class cloudconsul::snatch inherits cloudconsul {

  file { '/usr/local/bin/snatch':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/snatch'
  }


  file { '/etc/supervisor.d/snatch.conf':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/cloudconsul/snatch.supervisor'
  }

}

