class eventstore::service(
  $ensure = 'running'
) {
  $user = $eventstore::user
  $group = $eventstore::group
  $dir   = $eventstore::dir
  $log_dir = $eventstore::log_dir

  if $ensure = 'running' {
    svcutils::mixsvc { 'eventstore':
      enable      => true,
      user        => $user,
      group       => $group,
      log_dir     => $log_dir,
      exec        => "${dir}/EventStore.exe",
      args        => '',
      description => 'EventStore Server'
    }
  } else {
    svcutils::mixsvc { 'eventstore':
      ensure => 'absent'
    }
  }
}