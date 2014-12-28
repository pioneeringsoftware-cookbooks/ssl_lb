# -*- mode: ruby -*-
# vi: set ft=ruby :

# Set up the default Vagrant provider if not already set. Default to
# Parallels. Note, the box depends on the provider. Change the provider and you
# may need to adjust the box too. Change the default provisioner for Vagrant
# using:
#
# export VAGRANT_DEFAULT_PROVIDER=parallels
#
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'parallels' unless ENV['VAGRANT_DEFAULT_PROVIDER']

Vagrant.configure(2) do |config|
  # Install the Ubuntu box for Parallels using:
  #
  #   vagrant box add parallels/ubuntu-14.04
  #
  config.vm.box = 'parallels/ubuntu-14.04'
  config.berkshelf.enabled = true

  config.vm.define 'frontend' do |frontend|
    frontend.vm.network 'private_network', ip: '192.168.33.10'
    frontend.vm.provision 'chef_zero' do |chef|
      chef.add_recipe 'ssl_lb'
      chef.add_role 'ssl_lb_backend'
      chef.roles_path = 'roles'
    end
  end
end
