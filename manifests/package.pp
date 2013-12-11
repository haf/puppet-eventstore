class eventstore::package(
  $package_name = 'eventstore'
) {
  $dir     = $eventstore::dir
  $version = $eventstore::version
  $url     = $eventstore::url
  $ensure  = $eventstore::ensure

  if $eventstore::use_pkg {
    package { $package_name:
      ensure => $ensure,
    }
  } else {
    if $ensure == 'present' {
      wget::fetch { 'download_eventstore':
        source      => "$url",
        destination => "/usr/local/src/eventstore-$version.tgz",
        before      => Exec['untar_eventstore'],
      }
      exec { 'untar_eventstore':
        command => "tar xvzf /usr/local/src/eventstore-$version.tgz && mv eventstore eventstore-$version && rm start.sh",
        cwd     => '/opt',
        creates => "${dir}-$version",
        path    => ['/bin', '/usr/bin'],
        before  => File[$dir],
      }
      file { $dir:
        ensure => link,
        target => "${$dir}-$version",
      }
    } else {
      file {"/usr/local/src/eventstore-$version.tar.gz":
        ensure => absent,
      }
      file { "/usr/local/src/eventstore-$version":
        ensure => absent,
        force  => true,
      }
      file { $dir:
        ensure => absent,
      }
    }
  }
}