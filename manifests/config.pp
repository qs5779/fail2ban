# == Class: fail2ban::config
#
class fail2ban::config {

  file { $fail2ban::jail_directory:
    ensure  => 'directory',
    mode    => '0755',
    purge   => $fail2ban::purge_unmanaged_jails,
    force   => $fail2ban::purge_unmanaged_jails,
    recurse => $fail2ban::purge_unmanaged_jails,
    notify  => Service[fail2ban],
  }

  file { $fail2ban::filter_directory:
    ensure => 'directory',
  }

  ini_setting { 'fail2ban-local-dbpurgeage':
    ensure  => present,
    path    => "${fail2ban::fail2ban_d_directory}/puppet-managed.conf",
    section => 'Definition',
    setting => 'dbpurgeage',
    value   => $fail2ban::dbpurgeage,
    notify  => Service[fail2ban],
  }

  $defaults_file_path = "${fail2ban::jail_directory}/00-defaults-puppet.conf"

  file { $defaults_file_path:
    ensure  => 'file',
    content => template('fail2ban/jail-overrides.erb'),
    require => File[$fail2ban::jail_directory],
    notify  => Service[fail2ban],
  }

  if !$fail2ban::jails.empty {
    $jaildefaults = { ensure => 'present' }
    create_resources('fail2ban::jail', $fail2ban::jails, $jaildefaults)
  }

  if !$fail2ban::filters.empty {
    $filterdefaults = { ensure => 'present' }
    create_resources('fail2ban::filter', $fail2ban::filters, $filterdefaults)
  }

}
