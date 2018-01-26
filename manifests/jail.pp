# Setup a fail2ban jail.
#
define fail2ban::jail (
  Enum['present', 'absent', 'purged'] $ensure = 'present',
  Boolean $enabled                            = true,
  Optional[Array[String]] $port               = undef,
  Optional[Array[String]] $logpath            = undef,
  Optional[String] $banaction                 = undef,
  Optional[String] $banaction_allports        = undef,
  Optional[Array[String]] $action             = undef,
  Optional[String] $ignorecommand             = undef,
  Optional[String] $bantime                   = undef,
  Optional[String] $findtime                  = undef,
  Optional[Integer] $maxretry                 = undef,
  Optional[String] $backend                   = undef,
  Optional[String] $usedns                    = undef,
  Optional[Array[String]] $ignoreip           = undef,
  Optional[Integer] $order                    = $undef,
  Optional[String] $filter                    = undef,
  Optional[Array[String]] $protocol           = undef,
) {

  if $order { # we intentionally will not use 0 for order, as we use 00 for our overrides
    $jail_path_name = sprintf('%s/%02d-%s.conf', $fail2ban::$config_dir_path, $order, $name);
  }
  else {
    $jail_path_name = sprintf('%s/%s.conf', $fail2ban::$config_dir_path, $name);
  }

  if $ensure == 'present' {
    file { $jail_path_name:
      ensure => 'file',
      mode    => 0640,
      content => template('fail2ban/jail.erb');
    }
  }
  else {
    file { $jail_path_name:
      ensure => 'absent',
    }
  }
}
