# install and configure envconsul
class cloudconsul::consul_env inherits cloudconsul {
  include staging
  staging::file { "envconsul_${cloudconsul::env_version}.zip":
        source => "https://releases.hashicorp.com/envconsul/${cloudconsul::env_version}/envconsul_${cloudconsul::env_version}_linux_${::architecture}.zip",
      }
      -> file { "${::staging::path}/envconsul-${cloudconsul::env_version}":
        ensure => directory,
      }
      -> staging::extract { "envconsul_${cloudconsul::env_version}.zip":
        target  => "${::staging::path}/envconsul-${cloudconsul::env_version}",
        creates => "${::staging::path}/envconsul-${cloudconsul::env_version}/envconsul",
      }
      -> file {
        "${::staging::path}/envconsul-${cloudconsul::env_version}/envconsul":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        '/usr/local/bin/envconsul':
          ensure => link,
          target => "${::staging::path}/envconsul-${cloudconsul::env_version}/envconsul";
      }
}
