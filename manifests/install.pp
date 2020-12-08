# == Class: fail2ban::install
#
class fail2ban::install (
  String                  $ensure,
  Array[String]           $fail2ban_packages,
  Optional[Array[String]] $repo_packages,
  Optional[Array[String]] $extra_packages,
) {


  $_fail2ban_packages = $extra_packages ? {
    undef   => $fail2ban_packages,
    default => $fail2ban_packages + $extra_packages
  }

  $yumrepos = lookup('fail2ban::yumrepos', Hash, deep, {})
  unless empty($yumrepos) {
    $before_packages = $repo_packages ? {
      undef   => $_fail2ban_packages,
      default => $repo_packages
    }
    ensure_resources('yumrepo', $yumrepos, {'ensure' => 'present', before =>  Package[$before_packages] })
  }

  if ($ensure != 'absent') and ($repo_packages){
    ensure_packages($repo_packages, { ensure => $ensure, before =>  Package[$_fail2ban_packages]})
    # $_require = Package[$repo_packages]
  }
  # else {
  #   $_require = undef
  # }

  ensure_packages($_fail2ban_packages, { ensure => $ensure })
}
