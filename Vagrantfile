# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.8.0"

CONFIG = File.join(File.dirname(__FILE__), "config.rb")
FIRST_RUN_DONE = File.join(File.dirname(__FILE__), ".first_run_done")

if File.exist?(CONFIG)
  require CONFIG
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_version = "20170224.0.0"

  config.vm.provider :virtualbox do |vb|
    vb.gui = $vb_gui
    vb.memory = $vb_memory
    vb.cpus = $vb_cpus
    vb.name = $vb_name
  end

  if not File.exist?(FIRST_RUN_DONE)
    config.vm.provision "shell", path: "provisioning/test.sh", args: $locale
  else
    $scripts.each do |script|
      config.vm.provision "shell", path: "#{script}"
    end
  end

end
