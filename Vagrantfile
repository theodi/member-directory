# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

y = YAML.load File.open ".chef/rackspace_secrets.yaml"

Vagrant.configure("2") do |config|

  config.butcher.knife_config_path = '.chef/knife.rb'

  config.vm.define :directory_theodi_org_01 do |dto_01_config|
    dto_01_config.vm.box      = "dummy"
    dto_01_config.vm.hostname = "directory-01"

    dto_01_config.ssh.private_key_path = "./.chef/id_rsa"
    dto_01_config.ssh.username         = "root"

    dto_01_config.vm.provider :rackspace do |rs|
      rs.username        = y["username"]
      rs.api_key         = y["api_key"]
      rs.flavor          = /1GB/
      rs.image           = /Precise/
      rs.public_key_path = "./.chef/id_rsa.pub"
      rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
      rs.auth_url        = "lon.identity.api.rackspacecloud.com"
    end

    dto_01_config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"

    dto_01_config.vm.provision :chef_client do |chef|
      chef.node_name              = "directory-01"
      chef.environment            = "production"
      chef.chef_server_url        = "https://chef.theodi.org"
      chef.validation_client_name = "chef-validator"
      chef.validation_key_path    = ".chef/chef-validator.pem"
      chef.run_list               = chef.run_list = [
          "role[directory]"
      ]
    end
  end

  config.vm.define :directory_theodi_org_02 do |dto_02_config|
    dto_02_config.vm.box      = "dummy"
    dto_02_config.vm.hostname = "directory-02"

    dto_02_config.ssh.private_key_path = "./.chef/id_rsa"
    dto_02_config.ssh.username         = "root"

    dto_02_config.vm.provider :rackspace do |rs|
      rs.username        = y["username"]
      rs.api_key         = y["api_key"]
      rs.flavor          = /1GB/
      rs.image           = /Precise/
      rs.public_key_path = "./.chef/id_rsa.pub"
      rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
      rs.auth_url        = "lon.identity.api.rackspacecloud.com"
    end

    dto_02_config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"

    dto_02_config.vm.provision :chef_client do |chef|
      chef.node_name              = "directory-02"
      chef.environment            = "production"
      chef.chef_server_url        = "https://chef.theodi.org"
      chef.validation_client_name = "chef-validator"
      chef.validation_key_path    = ".chef/chef-validator.pem"
      chef.run_list               = chef.run_list = [
          "role[directory]"
      ]
    end

  end
end
