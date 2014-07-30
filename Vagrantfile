# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "commana/arsnova-debian-wheezy-puppet3-i386"
  	config.vm.box_url = "https://vagrantcloud.com/commana/arsnova-debian-wheezy-puppet3-i386"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--name", "we3-hw3"]
  end
  #

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./puppet/files", "/etc/puppet/files"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

	# node
  	config.vm.network "forwarded_port", guest: 3000, host: 3000
   # CouchDB
   config.vm.network "forwarded_port", guest: 5984, host: 5984
   # SonarQube
   config.vm.network "forwarded_port", guest: 9000, host: 9000
   # Jenkins
   config.vm.network "forwarded_port", guest: 9090, host: 9090

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.

  config.vm.provision "puppet" do |puppet|
	puppet.manifests_path = "puppet/manifests"
   puppet.module_path = "puppet/modules"
	puppet.manifest_file  = "debian.pp"
	puppet.options = "--verbose --debug"
  end

end
