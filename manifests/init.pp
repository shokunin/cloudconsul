# Class: cloudconsul
class cloudconsul (
  Boolean $enable_bind = false,
  ) {

  require supervisor
  include cloudconsul::consul

  if $enable_bind {
    include cloudconsul::bind
  }

}
