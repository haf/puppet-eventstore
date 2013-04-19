class eventstore(
  $ensure = 'present',
  $version = $eventstore::params::version,
  $dir     = $eventstore::params::dir,
  $user    = $eventstore::params::user,
  $group   = $eventstore::params::group,
  $log_dir = $eventstore::params::log_dir
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
    home   => $dir,
    group  => $group,
    require => Anchor['eventstore::start'],
    before  => Anchor['eventstore::end'],
  } ->
  
  class { 'eventstore::package':
    require => Anchor['eventstore::start'],
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