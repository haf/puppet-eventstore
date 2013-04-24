class eventstore::params {
  $version   = '1.0.1'
  $baseurl   = "http://download.geteventstore.com/binaries"
  $dir       = '/opt/eventstore'
  $log_dir   = '/var/log/eventstore'
  $data_dir  = '/var/lib/eventstore'
  $etc_dir   = '/etc/eventstore'
  $user      = 'eventstore'
  $group     = 'eventstore'
  $ip        = '127.0.0.1'
  $tcp_port  = 1113
  $http_port = 2113
  $stats_period_sec = 30
  $prefixes  = 'http://*:2113/'
}