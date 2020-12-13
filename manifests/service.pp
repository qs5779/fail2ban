# == Class: fail2ban::service
#
class fail2ban::service (
  Variant[Boolean,String] $ensure,
  Boolean                 $enable,
  String                  $service_name,
) {
  unless empty($service_name) {
    service { $service_name:
      ensure => $ensure,
      enable => $enable,
    }
  }
}
