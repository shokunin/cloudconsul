# Class: cloudconsul
class cloudconsul (
  Boolean $enable_bind     = false,
  Boolean $consul_server   = false,
  Boolean $consul_backup   = false,
  String $template_version = '0.19.4',
  String $env_version      = '0.7.3',
  String $prometheus_tag   = 'prometheus-node',
  ) {

  require supervisor
  include cloudconsul::consul
  include cloudconsul::consul_template
  include cloudconsul::consul_env

  if $enable_bind {
    include cloudconsul::bind
    include cloudconsul::snatch
  }

  if $consul_backup {
    include cloudconsul::backup
  }

}
