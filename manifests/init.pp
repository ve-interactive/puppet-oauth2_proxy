# == Class: oauth2_proxy
#
class oauth2_proxy(
  $user         = $::oauth2_proxy::params::user,
  $manage_user  = $::oauth2_proxy::params::manage_user,
  $group        = $::oauth2_proxy::params::group,
  $manage_group = $::oauth2_proxy::params::manage_group,
  $install_root = $::oauth2_proxy::params::install_root,
) inherits oauth2_proxy::params {
  validate_string($user)
  validate_bool($manage_user)
  validate_string($group)
  validate_bool($manage_group)
  validate_absolute_path($install_root)

  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => '/sbin/nologin',
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
  }

  anchor { '::oauth2_proxy::begin': } ->
    class { '::oauth2_proxy::install': } ~>
    Oauth2_proxy::Instance<| |> ->
      anchor { '::oauth2_proxy::end': }
}
