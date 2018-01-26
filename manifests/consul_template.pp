# install and configure consul
class cloudconsul::consul_template inherits cloudconsul {
  include staging
  staging::file { "consul-template_${cloudconsul::template_version}.zip":
        source => "https://releases.hashicorp.com/consul-template/${cloudconsul::template_version}/consul-template_${cloudconsul::template_version}_linux_${::architecture}.zip"
      } ->
      file { "${::staging::path}/consul-template-${cloudconsul::template_version}":
        ensure => directory,
      } ->
      staging::extract { "consul-template_${cloudconsul::template_version}.zip":
        target  => "${::staging::path}/consul-template-${cloudconsul::template_version}",
        creates => "${::staging::path}/consul-template-${cloudconsul::template_version}/consul-template",
      } ->
      file {
        "${::staging::path}/consul-template-${cloudconsul::template_version}/consul-template":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        '/usr/local/bin/consul-template':
          ensure => link,
          target => "${::staging::path}/consul-template-${cloudconsul::template_version}/consul-template";
      }
}
