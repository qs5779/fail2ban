# == Class: fail2ban::config
#
class fail2ban::config {

  # notify not needed because init manifest uses chaining arrows
  file { $fail2ban::jail_directory:
    ensure  => 'directory',
    mode    => '0755',
    purge   => $fail2ban::purge_unmanaged_jails,
    force   => $fail2ban::purge_unmanaged_jails,
    recurse => $fail2ban::purge_unmanaged_jails,
    # notify  => $fail2ban::service_notify,
  }

  file { $fail2ban::filter_directory:
    ensure => 'directory',
  }

  if $fail2ban::dbpurgeage {
    ini_setting { 'fail2ban-local-dbpurgeage':
      ensure  => present,
      path    => "${fail2ban::conf_d_directory}/puppet-managed.conf",
      section => 'Definition',
      setting => 'dbpurgeage',
      value   => $fail2ban::dbpurgeage,
      # notify  => $fail2ban::service_notify,
    }
  }
  $defaults_file_path = "${fail2ban::jail_directory}/00-defaults-puppet.conf"

  file { $defaults_file_path:
    ensure  => $fail2ban::file_ensure,
    content => template('fail2ban/jail-overrides.erb'),
    require => File[$fail2ban::jail_directory],
    # notify  => $fail2ban::service_notify,
  }

  if !$fail2ban::jails.empty {
    $jaildefaults = { ensure => $fail2ban::file_ensure }
    create_resources('fail2ban::jail', $fail2ban::jails, $jaildefaults)
  }

  if !$fail2ban::filters.empty {
    $filterdefaults = { ensure => $fail2ban::file_ensure }
    create_resources('fail2ban::filter', $fail2ban::filters, $filterdefaults)
  }

}
