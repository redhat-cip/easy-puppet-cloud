# vagrant plugin install vagrant-libvirt
Vagrant.configure("2") do |config|

  config.vm.define 'os-ci-test1' do |node|
    node.vm.hostname = 'os-ci-test1'
    node.vm.host_name = 'os-ci-test1'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.45'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.45'
  end

  config.vm.define 'os-ci-test2' do |node|
    node.vm.hostname = 'os-ci-test2'
    node.vm.host_name = 'os-ci-test2'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.46'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.46'
  end

  config.vm.define 'os-ci-test3' do |node|
    node.vm.hostname = 'os-ci-test3'
    node.vm.host_name = 'os-ci-test3'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.47'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.47'
  end

  # The puppet-master
  config.vm.define 'os-ci-test4' do |node|
    node.vm.hostname = 'os-ci-test4'
    node.vm.host_name = 'os-ci-test4'
    node.vm.box = "puppet-master"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.48'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.48'
    node.vm.provider :libvirt do |domain|
      domain.memory = 1024
    end
  end

  config.vm.define 'os-ci-test7' do |node|
    node.vm.hostname = 'os-ci-test7'
    node.vm.host_name = 'os-ci-test7'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.49'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.50'
  end

  config.vm.define 'os-ci-test8' do |node|
    node.vm.hostname = 'os-ci-test8'
    node.vm.host_name = 'os-ci-test8'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.52'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.52'
  end

  config.vm.define 'os-ci-test9' do |node|
    node.vm.hostname = 'os-ci-test9'
    node.vm.host_name = 'os-ci-test9'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.53'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.53'
  end

  config.vm.define 'os-ci-test10' do |node|
    node.vm.hostname = 'os-ci-test10'
    node.vm.host_name = 'os-ci-test10'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.54'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.54'
  end

  config.vm.define 'os-ci-test11' do |node|
    node.vm.hostname = 'os-ci-test11'
    node.vm.host_name = 'os-ci-test11'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.55'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.55'
  end

  config.vm.define 'os-ci-test12' do |node|
    node.vm.hostname = 'os-ci-test12'
    node.vm.host_name = 'os-ci-test12'
    node.vm.box = "openstack-full"
    node.vm.network :private_network,
      :libvirt__network_name => 'mgmt_internal',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.134.56'
    node.vm.network :private_network,
      :libvirt__network_name => 'public',
      :libvirt__netmask => '255.255.255.0',
      :libvirt__forward_mode => 'nat',
      :ip => '192.168.44.56'
  end

  config.vm.provider :libvirt do |domain|
    domain.memory = 512
    domain.cpus = 1
    domain.nested = true
    domain.volume_cache = 'none'
  end


  config.vm.synced_folder ".", "/vagrant", disabled: true

#  config.vm.provider :libvirt do |libvirt|
#    libvirt.driver = "qemu"
#    libvirt.host = "newserv.lebouder.net"
#    libvirt.connect_via_ssh = true
#    libvirt.username = "goneri"
#  end

end

