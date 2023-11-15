# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
  Vagrant.configure(2) do |config| 
    config.vm.box = "centos/8" 
    #config.vm.box_version = "20210210.0" 
    config.vm.provider "virtualbox" do |v| 
    v.memory = 256 
    v.cpus = 1 
  end 
  config.vm.define "lab9" do |lab9| 
    lab9.vm.network "private_network", type: "dhcp" 
    lab9.vm.hostname = "lab9"
    lab9.vm.provision "file", source: "InfoToEmail.sh", destination: "/tmp/InfoToEmail.sh"
    lab9.vm.provision "shell" , path: "script.sh"
  end 
end 
