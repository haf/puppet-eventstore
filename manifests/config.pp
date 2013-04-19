class eventstore::config(
  $ensure           = 'present',
  $ip               = '127.0.0.1', # eventstore crashes when given IPv6 arg
  $tcp_port         = 1113,
  $http_port        = 2113,
  $stats_period_sec = 30,
) {
  $log_dir     = $eventstore::log_dir
  $etc_dir     = $eventstore::etc_dir
  $data_dir    = $eventstore::data_dir
  $config_file = "$etc_dir/config.json"
  $user        = $eventstore::user
  $group       = $eventstore::group

  file { $config_file:
    ensure => $ensure,
    content => template('eventstore/config.json.erb'),
    owner   => $user,
    group   => $group,
  }
}