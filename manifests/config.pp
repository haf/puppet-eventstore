class eventstore::config(
  $ensure           = 'present'
) {
  # eventstore crashes when given IPv6 arg
  $ip               = $eventstore::ip
  $http_port        = $eventstore::http_port
  $tcp_port         = $eventstore::tcp_port
  $stats_period_sec = $eventstore::stats_period_sec
  $prefixes         = $eventstore::prefixes
  $log_dir          = $eventstore::log_dir
  $etc_dir          = $eventstore::etc_dir
  $data_dir         = $eventstore::data_dir
  $config_file      = "$etc_dir/config.json"
  $user             = $eventstore::user
  $group            = $eventstore::group

  file { [
    $log_dir,
    $etc_dir
  ]:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  file { $config_file:
    ensure => $ensure,
    content => template('eventstore/config.json.erb'),
    owner   => $user,
    group   => $group,
    require => File[$etc_dir],
  }
}
