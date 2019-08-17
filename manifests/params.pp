# == Class: fail2ban::params
#
class fail2ban::params {
  $package_name = $::osfamily ? {
    default => 'fail2ban',
  }

  $package_list = $::osfamily ? {
    default => undef,
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/fail2ban',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    'Debian' => 'sudo',
    default  => 'wheel',
  }

  $config_file_mode = $::osfamily ? {
    default => '0640',
  }

  $service_name = $::osfamily ? {
    default => 'fail2ban',
  }

  case $::osfamily {
    /^(Debian|RedHat|Archlinux)$/: {}
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
