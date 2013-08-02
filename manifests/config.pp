class eventstore::config(
  $ensure           = 'present',
  $ip, # eventstore crashes when given IPv6 arg
  $tcp_port,
  $http_port,
  $stats_period_sec,
  $prefixes
) {
  $log_dir         = $eventstore::log_dir
  $etc_dir         = $eventstore::etc_dir
  $data_dir        = $eventstore::data_dir
  $config_file     = "$etc_dir/config.json"
  $user            = $eventstore::user
  $group           = $eventstore::group
  $manage_firewall = $eventstore::manage_firewall

  file { [$log_dir, $etc_dir]:
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

  if $manage_firewall {
    firewall { "100 allow eventstore:$tcp_port":
      proto  => 'tcp',
      state  => ['NEW'],
      dport  => $tcp_port,
      action => 'accept',
    }
    firewall { "101 allow eventstore:$http_port":
      proto  => 'tcp',
      state  => ['NEW'],
      dport  => $http_port,
      action => 'accept',
    }
  }
}