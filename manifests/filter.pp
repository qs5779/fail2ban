# Setup a fail2ban filter.
#
define fail2ban::filter (
  Enum['present', 'absent', 'purged'] $ensure,
  String $filtername         = $title,
  String $daemon             = '',
  String $journalmatch       = '',
  Array[String] $ibefore     = [],
  Array[String] $failregex   = [],
  Array[String] $ignoreregex = [],
) {

  $filter_path_name = sprintf('%s/%s.local', $fail2ban::filter_directory, $filtername)

  if $ensure == 'present' {
    file { $filter_path_name:
      ensure  => 'file',
      content => template('fail2ban/filter.erb'),
      require => File[$fail2ban::filter_directory],
      notify  => Service[fail2ban],
    }
  }
  else {
    file { $filter_path_name:
      ensure => 'absent',
    }
  }
}
