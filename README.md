# puppet-eventstore

A puppet module for deploying [GregStore](http://geteventstore.com).

## Usage

Class:

``` puppet
class { 'eventstore': }
```

Anti-class:
``` puppet
class { 'eventstore':
  ensure => absent,
}
```
