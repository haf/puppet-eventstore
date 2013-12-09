class eventstore(
  $ensure           = 'present',
  $version          = $eventstore::params::version,
  $dir              = $eventstore::params::dir,
  $user             = $eventstore::params::user,
  $group            = $eventstore::params::group,
  $log_dir          = $eventstore::params::log_dir,
  $etc_dir          = $eventstore::params::etc_dir,
  $data_dir         = $eventstore::params::data_dir,
  $ip               = $eventstore::params::ip,
  $http_port        = $eventstore::params::http_port,
  $tcp_port         = $eventstore::params::tcp_port,
  $stats_period_sec = $eventstore::params::stats_period_sec,
  $prefixes         = $eventstore::params::prefixes,
  $manage_firewall  = hiera('manage_firewalls', false),
) inherits eventstore::params {
  $url    = "$eventstore::params::baseurl/eventstore-mono-$version.tgz"
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
    ip               => $ip,
    http_port        => $http_port,
    tcp_port         => $tcp_port,
    stats_period_sec => $stats_period_sec,
    prefixes         => $prefixes,
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