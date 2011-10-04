Vagrant::Config.run do |config|

  # base box
  config.vm.box = "squeeze-2011-09-29"

  # add a gui
  # config.vm.boot_mode = :gui

  # set memory to 512MB
  config.vm.customize do |vm|
    vm.memory_size = 1024 #512
  end

  config.vm.provision :puppet do |puppet|
  # config.vm.provision :puppet, :module_path => "modules", :options => "--verbose --debug" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "base.pp"
  end

  # add a hostmaster Aegir server on a shared host-only network
  config.vm.define "hm" do |hm_config|
    hm_config.vm.network("192.168.32.10")
    hm_config.vm.host_name = "HostMaster"
    hm_config.vm.customize do |vm|
      vm.name = "Host Master"
    end
    hm_config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "hostmaster.pp"
    end
  end

=begin
  # add several hostslave Aegir servers on a shared host-only network
  (1..1).each do |index|
    config.vm.define "hs#{index}" do |hs_config|
      hs_config.vm.network("192.168.32.1#{index}")
      hs_config.vm.host_name = "HostSlave#{index}"
      hs_config.vm.customize do |vm|
        vm.name = "Host Slave #{index}"
      end
      hs_config.vm.provision :puppet do |puppet|
        puppet.manifest_file = "hostslave.pp"
      end
    end
  end
=end
end
