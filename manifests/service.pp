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
    supervisor::service { 'eventstore':
      directory   => $data_dir,
      user        => $user,
      group       => $group,
      command     => "/usr/local/bin/mono --gc=sgen ${dir}/EventStore.SingleNode.exe \
--run-projections --db=$data_dir --logsdir=$log_dir --config=$etc_dir \
--http-port=$http_port --tcp-port=$tcp_port --ip=$ip --prefixes=$prefixes",
      require     => File[$data_dir],
    }
  } else {
    supervisor::service { 'eventstore':
      ensure => 'absent'
    }
  }
}