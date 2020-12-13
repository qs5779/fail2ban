# Setup a fail2ban filter.
#
define fail2ban::filter (
  Enum['present', 'absent', 'purged'] $ensure,
  Stdlib::Absolutepath                $filter_dir,
  String                              $filtername = $title,
  String                              $daemon = '',
  String                              $journalmatch = '',
  Array[String]                       $ibefore = [],
  Array[String]                       $failregex = [],
  Array[String]                       $ignoreregex = [],
) {

  $filter_path_name = sprintf('%s/%s.local', $filter_dir, $filtername)

  if $ensure == 'present' {
    file { $filter_path_name:
      ensure  => 'file',
      content => template('fail2ban/filter.erb'),
    }
  }
  else {
    file { $filter_path_name:
      ensure => 'absent',
    }
  }
}
