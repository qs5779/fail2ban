# == Class: fail2ban
#
class fail2ban (
  Optional[Enum['absent', 'present', 'purged']] $package_ensure = 'present',
  Optional[String] $package_name                                = $::fail2ban::params::package_name,
  Optional[Array[String]] $package_list                         = $::fail2ban::params::package_list,
  Optional[String] $config_dir_path                             = $::fail2ban::params::config_dir_path,
  Optional[String] $config_file_path                            = $::fail2ban::params::config_file_path,
  Optional[String] $config_file_owner                           = $::fail2ban::params::config_file_owner,
  Optional[String] $config_file_group                           = $::fail2ban::params::config_file_group,
  Optional[String] $config_file_mode                            = $::fail2ban::params::config_file_mode,
  Optional[Enum['running', 'stopped']] $service_ensure          = 'running',
  Optional[String] $service_name                                = $::fail2ban::params::service_name,
  Optional[Boolean] $service_enable                             = true,
  Optional[String] $banaction                                   = undef,
  Optional[String] $banaction_allports                          = undef,
  Optional[String] $action                                      = undef,
  Optional[String] $bantime                                     = undef,
  Optional[String] $backend                                     = undef,
  Optional[String] $email                                       = "fail2ban@${::domain}",
  Optional[Integer] $maxretry                                   = undef,
  Optional[Array[String]] $whitelist                            = ['127.0.0.1/8', '::1'],
  Optional[Hash] $jails                                         = { sshd => { ensure => present } },
) inherits ::fail2ban::params {
  validate_re($package_ensure, '^(absent|latest|present|purged)$')
  validate_string($package_name)
  if $package_list { validate_array($package_list) }

  validate_absolute_path($config_dir_path)

  validate_re($service_ensure, '^(running|stopped)$')
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

  $jails_directory = "${$config_file_path}/jails.d"

  File {
    owner => $config_file_owner,
    group => $config_file_group,
    mode  => $config_file_mode,
  }

  anchor { 'fail2ban::begin': } ->
  class { '::fail2ban::install': } ->
  class { '::fail2ban::config': } ~>
  class { '::fail2ban::service': } ->
  anchor { 'fail2ban::end': }
}
