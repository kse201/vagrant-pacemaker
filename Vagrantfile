# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  num_instances = 1
  instance_name_prefix = 'node'
  userdata = File.read('userdata')

  config.vm.box = "centos/7"

  config.vm.provider 'virtualbox' do |vb|
    vb.cpus = 1
    vb.memory = 1024
    vb.gui = false
  end

  config.vm.provision :shell, privileged: false, inline: userdata

  (1..num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [instance_name_prefix, i] do |config|
      config.vm.hostname = vm_name

      ip = "172.17.8.#{i + 100}"
      config.vm.network :private_network, ip: ip
    end
  end
end
