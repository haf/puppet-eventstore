class eventstore::service(
  $ensure = 'running'
) {
  $user      = $eventstore::user
  $group     = $eventstore::group
  $dir       = $eventstore::dir
  $log_dir   = $eventstore::log_dir
  $data_dir  = $eventstore::data_dir
  $etc_dir   = $eventstore::etc_dir
  $ip        = $eventstore::config::ip
  $tcp_port  = $eventstore::config::tcp_port
  $http_port = $eventstore::config::http_port
  $prefixes  = $eventstore::config::prefixes

  file { $data_dir:
    ensure => directory,
    owner  => $user,
  }

  if $ensure == 'running' {
    svcutils::mixsvc { 'eventstore':
      home        => $data_dir,
      enable      => true,
      user        => $user,
      group       => $group,
      log_dir     => $log_dir,
      exec        => "/usr/local/bin/mono --gc=sgen ${dir}/EventStore.SingleNode.exe --run-projections --db=$data_dir --logsdir=$log_dir --config=$etc_dir \
--http-port=$http_port --tcp-port=$tcp_port --ip=$ip --prefixes=$prefixes",
      description => 'EventStore SingleNode Server',
      require     => File[$data_dir],
    }
  } else {
    svcutils::mixsvc { 'eventstore':
      ensure => 'absent'
    }
  }
}