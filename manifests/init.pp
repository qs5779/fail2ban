# == Class: fail2ban
#
class fail2ban (
  Enum[
    'absent',
    'present',
    'purged',
    'latest' ] $package_ensure                = 'present',
  String $package_name                        = $::fail2ban::params::package_name,
  Stdlib::Absolutepath $config_dir_path       = $::fail2ban::params::config_dir_path,
  String $config_file_owner                   = $::fail2ban::params::config_file_owner,
  String $config_file_group                   = $::fail2ban::params::config_file_group,
  String $config_file_mode                    = $::fail2ban::params::config_file_mode,
  Enum['running', 'stopped'] $service_ensure  = 'running',
  String $service_name                        = $::fail2ban::params::service_name,
  Boolean $service_enable                     = true,
  Boolean $purge_unmanaged_jails              = true,
  Hash $jails                                 = { sshd => { ensure => present } },
  Hash $filters                               = {},
  Optional[Array[String]] $package_list       = $::fail2ban::params::package_list,
  Optional[String] $banaction                 = undef,
  Optional[String] $banaction_allports        = undef,
  Optional[String] $action                    = undef,
  Optional[String] $bantime                   = '7200',
  Optional[String] $findtime                  = undef,
  Optional[String] $backend                   = undef,
  Optional[String] $email                     = 'root@localhost',
  Optional[String] $sender                     = "fail2ban@${::domain}",
  Optional[Integer] $maxretry                 = undef,
  Optional[Array[String]] $whitelist          = ['127.0.0.1/8', '::1'],
  Optional[Integer] $dbpurgeage               = undef,
) inherits ::fail2ban::params {

  case $package_ensure {
    'absent', 'purged': {
      $_service_ensure    = 'stopped'
      $_service_enable    = false
      $file_ensure        = 'absent'
    }
    default: {
      $_service_ensure    = $service_ensure
      $_service_enable    = $service_enable
      $file_ensure        = 'file'
    }
  }

  $service_notify = $service_name ? {
    true    => Service[$service_name],
    default => undef
  }

  $conf_d_directory = "${config_dir_path}/fail2ban.d"
  $jail_directory = "${config_dir_path}/jail.d"
  $filter_directory = "${config_dir_path}/filter.d"

  File {
    owner => $config_file_owner,
    group => $config_file_group,
    mode  => $config_file_mode,
  }

  anchor { 'fail2ban::begin': }
    -> class { '::fail2ban::install': }
    -> class { '::fail2ban::config': }
    ~> class { '::fail2ban::service': }
    -> anchor { 'fail2ban::end': }
}
