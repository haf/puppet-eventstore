class eventstore(
  $ensure   = 'present',
  $version  = $eventstore::params::version,
  $dir      = $eventstore::params::dir,
  $user     = $eventstore::params::user,
  $group    = $eventstore::params::group,
  $log_dir  = $eventstore::params::log_dir,
  $etc_dir  = $eventstore::params::etc_dir,
  $data_dir = $eventstore::params::data_dir
) inherits eventstore::params {
  $url    = "$eventstore::params::baseurl/eventstore-mono-$version.tgz"

  anchor { 'eventstore::start': }

  group { $group:
    ensure => present,
    system => true,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  } ->

  svcutils::svcuser { $user:
    group   => $group,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  } ->

  class { 'eventstore::package':
    require => [
      Anchor['eventstore::start'],
      Class['mono'],
    ],
    before  => Anchor['eventstore::end'],
  } ->

  class { 'eventstore::config':
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  } ~>

  class { 'eventstore::service':
    ensure => running,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  }

  anchor { 'eventstore::end': }
}