# -*- mode: ruby -*-
# vi: set ft=ruby :

#   name => [ip_suffix, memory, box]
nodes = {
    'os-ci-test1'  => [45, 1024, "openstack-full"],
    'os-ci-test2'  => [46, 1024, "openstack-full"],
    'os-ci-test3'  => [47, 1024, "openstack-full"],
    'os-ci-test4'  => [48, 1024, "puppet-master"],
    'os-ci-test5'  => [49, 512,  "openstack-full"],
    'os-ci-test7'  => [51, 512,  "openstack-full"],
    'os-ci-test8'  => [52, 512,  "openstack-full"],
    'os-ci-test9'  => [53, 512,  "openstack-full"],
    'os-ci-test10' => [54, 512,  "openstack-full"],
    'os-ci-test11' => [55, 512,  "openstack-full"],
}

Vagrant.configure("2") do |config|

  nodes.each do |prefix, (ip_suffix, memory, role)|
    hostname = "#{prefix}"

    config.vm.define "#{hostname}" do |node|
      node.vm.hostname  = "#{hostname}"
      node.vm.host_name = "#{hostname}"
      node.vm.synced_folder ".",
                            "/vagrant",
                            disabled: true
      node.vm.network :private_network,
                      :libvirt__network_name => 'mgmt_internal',
                      :ip                    => "192.168.134.#{ip_suffix}",
                      :libvirt__netmask      => '255.255.255.0',
                      :libvirt__forward_mode => 'nat'
      node.vm.network :private_network,
                      :libvirt__network_name => 'public',
                      :ip                    => "192.168.44.#{ip_suffix}",
                      :libvirt__netmask      => '255.255.255.0',
                      :libvirt__forward_mode => 'nat'
      node.vm.box = "#{role}"

      node.vm.provider :libvirt do |domain|
        domain.memory       = memory
        domain.cpus         = 1
        domain.nested       = true
        domain.volume_cache = 'none'
      end
    end
  end
end

