# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "doom"
  config.vm.network "forwarded_port", guest: 4000, host: 4000
  config.vm.provision "shell", path: "provision.sh", privileged: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
end
