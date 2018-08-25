# == Class: fail2ban
#
class fail2ban (
  Enum[
    'absent',
    'present',
    'purged',
    'latest' ] $package_ensure                = 'present',
  String $package_name                        = $::fail2ban::params::package_name,
  String $config_dir_path                     = $::fail2ban::params::config_dir_path,
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
  Optional[String] $email                     = "fail2ban@${::domain}",
  Optional[Integer] $maxretry                 = undef,
  Optional[Array[String]] $whitelist          = ['127.0.0.1/8', '::1'],
) inherits ::fail2ban::params {

  validate_string($package_name)
  if $package_list { validate_array($package_list) }

  validate_absolute_path($config_dir_path)

  validate_string($service_name)
  validate_bool($service_enable)

  if $package_ensure == 'absent' {
  #  $config_dir_ensure  = 'directory'
  #  $config_file_ensure = 'present'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } elsif $package_ensure == 'purged' {
    #$config_dir_ensure  = 'absent'
    #$config_file_ensure = 'absent'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } else {
    #$config_dir_ensure  = 'directory'
    #$config_file_ensure = 'present'
    $_service_ensure    = $service_ensure
    $_service_enable    = $service_enable
  }

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
