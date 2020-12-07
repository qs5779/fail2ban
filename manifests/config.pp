# == Class: fail2ban::config
#
class fail2ban::config (
  String                            $ensure,
  Stdlib::Absolutepath              $config_dir_path,
  Boolean                           $purge_unmanaged_jails,
  Optional[Variant[String,Integer]] $dbpurgeage,
  Hash                              $jails,
  Hash                              $filters,
) {
  if $ensure =~ /absent|purge/ {

    file{$config_dir_path:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }
  else {
    $conf_d_directory = "${config_dir_path}/fail2ban.d"
    $jail_directory = "${config_dir_path}/jail.d"
    $filter_directory = "${config_dir_path}/filter.d"

    # notify not needed because init manifest uses chaining arrows
    file { $jail_directory:
      ensure  => 'directory',
      mode    => '0755',
      purge   => $purge_unmanaged_jails,
      force   => $purge_unmanaged_jails,
      recurse => $purge_unmanaged_jails,
    }

    file { $filter_directory:
      ensure => 'directory',
    }

    if $dbpurgeage {
      ini_setting { 'fail2ban-local-dbpurgeage':
        ensure  => present,
        path    => "${conf_d_directory}/puppet-managed.conf",
        section => 'Definition',
        setting => 'dbpurgeage',
        value   => $dbpurgeage,
      }
    }
    $defaults_file_path = "${jail_directory}/00-defaults-puppet.conf"

    file { $defaults_file_path:
      ensure  => file,
      content => template('fail2ban/jail-overrides.erb'),
      require => File[$jail_directory],
    }

    if !$jails.empty {
      $jaildefaults = { ensure => 'present', jail_dir => $jail_directory }
      create_resources('fail2ban::jail', $jails, $jaildefaults)
    }

    if !$filters.empty {
      $filterdefaults = { ensure => 'file', filter_dir => $filter_directory }
      create_resources('fail2ban::filter', $filters, $filterdefaults)
    }
  }
}
