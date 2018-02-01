# Class: cloudconsul
class cloudconsul (
  Boolean $enable_bind = false,
  Boolean $consul_server = false,
  String $template_version = '0.19.4',
  ) {

  require supervisor
  include cloudconsul::consul
  include cloudconsul::consul_template

  if $enable_bind {
    include cloudconsul::bind
    include cloudconsul::snatch
  }

}
