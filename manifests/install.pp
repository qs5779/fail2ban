# == Class: fail2ban::install
#
class fail2ban::install {
  if $::fail2ban::package_name {
    package { 'fail2ban':
      ensure => $::fail2ban::package_ensure,
    }
  }

  if $::fail2ban::package_list {
    ensure_resource('package', $::fail2ban::package_list, { 'ensure' => $::fail2ban::package_ensure })
  }
}
