# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos-6.4-x64'
  config.vm.box_url = 'http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box'
  # config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 1113, host: 1113
  config.vm.network "forwarded_port", guest: 2113, host: 2113
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path    = "modules"
    puppet.manifest_file  = "site.pp"
    #puppet.options = %W[--hiera_config /vagrant/puppet/vagrant_hiera.yaml]
    # Take any FACTER_ prefixed environment variable and set it as a fact for
    # vagrant to give to puppet during provisioning.
    puppet.facter = {}
    ENV.each do |key, value|
      next unless key =~ /^FACTER_/
      puppet.facter[key.gsub(/^FACTER_/, "")] = value
    end
  end
end
