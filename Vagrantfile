# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.synced_folder ".", "/etc/box-config"

  config.vm.define "ubuntu" do |ubuntu|
    config.vm.box = "ubuntu/vivid64"
    config.vm.hostname = "ubuntu.box-config.dev"
    config.vm.network :forwarded_port, guest: 22, host: 2223
  end

  config.vm.define "arch" do |arch|
    config.vm.box = "ogarcia/archlinux-201508-x64"
    config.vm.hostname = "arch.box-config.dev"
    config.vm.network :forwarded_port, guest: 22, host: 2224
  end

end
