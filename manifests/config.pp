# == Class: fail2ban::config
#
class fail2ban::config {

  $defaults_file_path = "${fail2ban::jails_directory}/00-defaults-puppet.conf"

  file { $defaults_file_path:
    ensure  => 'file',
    content => template('fail2ban/jail-overrides.erb')
    notify => Service[fail2ban],
  }

  if $fail2ban::jails {

    $defaults { ensure => 'present' }
    create_resources('fail2ban::jail', $fail2ban::jails, $defaults)
  }

  $purge_packaged_defaults = [
    '00-firewalld.conf', # RedHat|CentOS|Scientific
    '00-systemd.conf', # RedHat|CentOS|Scientific
    'defaults-debian.conf', #debian, ubuntu
  ]

  $purge_packaged_defaults.each | $fn | {
    file { "${fail2ban::jails_directory}/${fn}":
      ensure  => 'absent',
      notify => Service[fail2ban]
    }
  }
}
