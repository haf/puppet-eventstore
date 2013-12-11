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
  $use_pkg          = true,
  $manage_firewall  = hiera('manage_firewall', false),
) {
  $url    = "http://download.geteventstore.com/binaries/eventstore-mono-$version.tgz"
  $home   = $dir

  anchor { 'eventstore::start': }

  group { $group:
    ensure  => present,
    system  => true,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  }

  user { $user:
    ensure  => $ensure,
    gid     => $group,
    home    => $home,
    system  => true,
    require => [
      Anchor['eventstore::start'],
      Group[$group]
    ],
    before  => Anchor['eventstore::end'],
  }

  class { 'eventstore::package':
    require => [
      Anchor['eventstore::start'],
      Class['mono'],
    ],
    before  => Anchor['eventstore::end'],
  } ->

  class { 'eventstore::config':
    require          => Anchor['eventstore::start'],
    before           => Anchor['eventstore::end'],
  } ~>

  class { 'eventstore::service':
    ensure => running,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  }

  anchor { 'eventstore::end': }
}
