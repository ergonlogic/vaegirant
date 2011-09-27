Vagrant::Config.run do |config|

  # base box
  config.vm.box = "updated.box"

  # add a gui
  # config.vm.boot_mode = :gui

  # set memory to 512MB
  config.vm.customize do |vm|
    vm.memory_size = 512
  end

  # add a hostmaster Aegir server on a shared host-only network
  config.vm.define :hostmaster do |hm_config|
    hm_config.vm.network("192.168.32.10")
    hm_config.vm.host_name = "HostMaster"
    hm_config.vm.customize do |vm|
      vm.name = "Host Master"
    end
  end

  # add several hostslave Aegir servers on a shared host-only network
  config.vm.define :hostslave0 do |hs_config|
    hs_config.vm.network("192.168.32.11")
    hs_config.vm.host_name = "HostSlave0"
    hs_config.vm.customize do |vm|
      vm.name = "Host Slave 0"
    end
  end
end
