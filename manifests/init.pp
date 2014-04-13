class eventstore(
  $ensure           = 'present',
  $version          = '2.0.1',
  $dir              = '/opt/eventstore',
  $log_dir          = '/var/log/eventstore',
  $etc_dir          = '/etc/eventstore',
  $data_dir         = '/var/lib/eventstore',
  $user             = 'eventstore',
  $group            = 'eventstore',
  $ip               = '127.0.0.1',
  $tcp_port         = 1113,
  $http_port        = 2113,
  $stats_period_sec = 30,
  $prefixes         = 'http://*:2113/',
# undocumented flag from EventStore:
#  $run_projections  = true,
  $use_pkg          = true
) {
  $url    = "http://download.geteventstore.com/binaries/eventstore-mono-$version.tgz"
  $home   = $dir

  group { $group:
    ensure  => present,
    system  => true,
  }

  user { $user:
    ensure  => $ensure,
    gid     => $group,
    home    => $home,
    system  => true,
    require => Group[$group]
  }

  class { 'eventstore::package': 
    require => Class['mono'],
  } ->

  class { 'eventstore::config': } ~>

  class { 'eventstore::service': }

  contain eventstore::service, eventstore::config, eventstore::package
}
