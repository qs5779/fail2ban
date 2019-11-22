# == Class: fail2ban::install
#
class fail2ban::install {
  if $::fail2ban::package_name {
    package { $::fail2ban::package_name:
      ensure => $::fail2ban::package_ensure,
    }
  }

  if ($::fail2ban::package_list) and (!empty($::fail2ban::package_list)) {
    ensure_packages($::fail2ban::package_list, { 'ensure' => $::fail2ban::package_ensure })
  }
}
