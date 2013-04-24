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

For all possible parameters, have a look at `class eventstore` [here](https://github.com/haf/puppet-eventstore/blob/master/manifests/init.pp#L1).
