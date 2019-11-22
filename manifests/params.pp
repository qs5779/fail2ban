# == Class: fail2ban::params
#
class fail2ban::params {

  case $::osfamily {
    'RedHat', 'Archlinux': {
      $_wheel = 'wheel'
    }
    'Debian': {
      $_wheel = 'sudo'
    }
    default: {
      fail("${facts['os']['family']} not supported.")
    }
  }

  $package_name = 'fail2ban'
  $package_list = undef
  $config_dir_path = '/etc/fail2ban'
  $config_file_owner = 'root'
  $config_file_group = $_wheel
  $config_file_mode = '0640'
  $service_name = 'fail2ban'
}
