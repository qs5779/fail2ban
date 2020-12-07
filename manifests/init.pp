# == Class: fail2ban
#
class fail2ban (
  Enum['absent','present','latest'] $ensure,
  Array[String]                     $fail2ban_packages,
  Stdlib::Absolutepath              $config_dir_path,
  String                            $config_file_owner,
  String                            $config_file_group,
  String                            $config_file_mode,
  String                            $service_name,
  Hash                              $jails,
  Enum['running','stopped']         $service_ensure = 'running',
  Boolean                           $service_enable = true,
  Boolean                           $purge_unmanaged_jails = true,
  Hash                              $filters = {},
  String                            $bantime = '7200',
  String                            $email = 'root@localhost',
  String                            $sender = "fail2ban@${::domain}",
  Array[String]                     $whitelist = ['127.0.0.1/8', '::1'],
  Optional[String]                  $banaction = undef,
  Optional[String]                  $banaction_allports = undef,
  Optional[String]                  $action = undef,
  Optional[String]                  $findtime = undef,
  Optional[String]                  $backend = undef,
  Optional[Integer]                 $maxretry = undef,
  Optional[Variant[String,Integer]] $dbpurgeage = undef,
  Optional[Array[String]]           $extra_packages = undef,
  Optional[Array[String]]           $repo_packages = undef,
) {

  case $ensure {
    'absent', 'purged': {
      $_service_ensure    = 'stopped'
      $_service_enable    = false
    }
    default: {
      $_service_ensure    = $service_ensure
      $_service_enable    = $service_enable
    }
  }

  File {
    owner => $config_file_owner,
    group => $config_file_group,
    mode  => $config_file_mode,
  }

  class { 'fail2ban::install':
    ensure            => $ensure,
    fail2ban_packages => $fail2ban_packages,
    repo_packages     => $repo_packages,
    extra_packages    => $extra_packages,
  }
  -> class { 'fail2ban::config':
    ensure                => $ensure,
    config_dir_path       => $config_dir_path,
    purge_unmanaged_jails => $purge_unmanaged_jails,
    dbpurgeage            => $dbpurgeage,
    jails                 => $jails,
    filters               => $filters
  }
  ~> class { 'fail2ban::service':
    ensure       => $_service_ensure,
    enable       => $_service_enable,
    service_name => $service_name
  }
}
