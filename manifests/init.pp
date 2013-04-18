class eventstore(
  $ensure = 'present',
  $version = $eventstore::params::version,
  $dir     = $eventstore::params::dir
) inherits eventstore::params {
  $url    = "$eventstore::params::baseurl/eventstore-mono-$version.tgz"
}