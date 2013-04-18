class eventstore::package {
  $dir = $eventstore::dir
  $version = $eventstore::version
  $url = $eventstore::url
  $ensure = $eventstore::ensure
  
  if $ensure = 'present' {
    wget::fetch { 'download_eventstore':
      source      => "$url",
      destination => "/usr/local/src/eventstore-$version.tar.gz",
      before      => Exec['untar_riemann'],
    }

    exec { 'untar_riemann':
      command => "tar xvfj /usr/local/src/eventstore-$version.tar.bz2",
      cwd     => '/opt',
      creates => "${dir}-$version",
      path    => ['/bin', '/usr/bin'],
      before  => File[dir],
    }
  } else{
    
  }
  
}