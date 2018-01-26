# == Class: fail2ban::config
#
class fail2ban::config {

  file { $fail2ban::jails_directory:
    ensure  => 'directory',
    mode    => '0755',
    purge   => $fail2ban::purge_unmanaged_jails,
    force   => $fail2ban::purge_unmanaged_jails,
    recurse => $fail2ban::purge_unmanaged_jails,
    notify  => Service[fail2ban],
  }

  $defaults_file_path = "${fail2ban::jails_directory}/00-defaults-puppet.conf"

  file { $defaults_file_path:
    ensure  => 'file',
    content => template('fail2ban/jail-overrides.erb'),
    require => File[$fail2ban::jails_directory],
    notify  => Service[fail2ban],
  }

  if $fail2ban::jails {
    $defaults = { ensure => 'present' }
    create_resources('fail2ban::jail', $fail2ban::jails, $defaults)
  }

}
