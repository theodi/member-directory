# -*- mode: ruby -*-
# vi: set ft=ruby :

# -*- mode: ruby -*-
# vi: set ft=ruby :

defaults = {
  count: 1,
  flavor: /2GB/,
  image: /Trusty/,
  run_list: [
    'recipe[chef_directory]'
  ]
}

nodesets = [
  {
    name: 'directory',
    count: 3,
    chef_env: 'directory-prod'
  }
]

require "yaml"

y = YAML.load File.open ".chef/rackspace_secrets.yaml"

Vagrant.configure("2") do |config|

  config.butcher.enabled    = true
  config.butcher.verify_ssl = false

  nodesets.each do |set|
    set = defaults.merge(set)

    set[:count].times do |num|
      index = "%02d" % [num + 1]
      chef_name = "%s-%s" % [
        set[:name].gsub('_', '-'),
        index
      ]

      vagrant_name = "%s_theodi_org_%s" % [
        set[:name],
        index
      ]

      config.vm.define :"#{set[:name]}_theodi_org_#{index}" do |config|
        config.vm.box      = "dummy"
        config.vm.hostname = chef_name

        config.ssh.private_key_path = "./.chef/id_rsa"
        config.ssh.username         = "root"

      #  config.ssh.private_key_path = "~/.ssh/id_rsa"
      #  config.ssh.username         = "odi"

        config.vm.provider :rackspace do |rs|
          rs.username         = y["username"]
          rs.api_key          = y["api_key"]
          rs.flavor           = set[:flavor]
          rs.image            = set[:image]
          rs.public_key_path  = "./.chef/id_rsa.pub"
          rs.rackspace_region = :lon
        end

        config.vm.provision :shell, :inline => "wget https://opscode.com/chef/install.sh && bash install.sh"

        config.vm.provision :chef_client do |chef|
          chef.node_name              = chef_name
          chef.environment            = "#{set[:chef_env]}"
          chef.chef_server_url        = "https://chef.theodi.org"
          chef.validation_client_name = "chef-validator"
          chef.validation_key_path    = ".chef/chef-validator.pem"
          chef.run_list               = set[:run_list]
        end
      end
    end
  end

###  config.vm.define :directory_theodi_org_01 do |dto_01_config|
###    dto_01_config.vm.box      = "dummy"
###    dto_01_config.vm.hostname = "directory-01"
###
###    dto_01_config.ssh.private_key_path = "./.chef/id_rsa"
###    dto_01_config.ssh.username         = "root"
###
###    dto_01_config.vm.provider :rackspace do |rs|
###      rs.username        = y["username"]
###      rs.api_key         = y["api_key"]
###      rs.flavor          = /2GB/
###      rs.image           = /Precise/
###      rs.public_key_path = "./.chef/id_rsa.pub"
###    #  rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
###    #  rs.auth_url        = "lon.identity.api.rackspacecloud.com"
###      rs.rackspace_region = :lon
###    end
###
####    dto_01_config.vm.provider :virtualbox do |vb|
####      stuff
####    end
###
###    dto_01_config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
###
###    dto_01_config.vm.provision :chef_client do |chef|
###      chef.node_name              = "directory-01"
###      chef.environment            = "production"
###      chef.chef_server_url        = "https://chef.theodi.org"
###      chef.validation_client_name = "chef-validator"
###      chef.validation_key_path    = ".chef/chef-validator.pem"
###      chef.run_list               = chef.run_list = [
###          "role[directory]"
###      ]
###    end
###  end
###
###  config.vm.define :directory_theodi_org_02 do |dto_02_config|
###    dto_02_config.vm.box      = "dummy"
###    dto_02_config.vm.hostname = "directory-02"
###
###    dto_02_config.ssh.private_key_path = "./.chef/id_rsa"
###    dto_02_config.ssh.username         = "root"
###
###    dto_02_config.vm.provider :rackspace do |rs|
###      rs.username        = y["username"]
###      rs.api_key         = y["api_key"]
###      rs.flavor          = /1GB/
###      rs.image           = /Precise/
###      rs.public_key_path = "./.chef/id_rsa.pub"
###      #  rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
###      #  rs.auth_url        = "lon.identity.api.rackspacecloud.com"
###        rs.rackspace_region = :lon
###    end
###
###    dto_02_config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
###
###    dto_02_config.vm.provision :chef_client do |chef|
###      chef.node_name              = "directory-02"
###      chef.environment            = "production"
###      chef.chef_server_url        = "https://chef.theodi.org"
###      chef.validation_client_name = "chef-validator"
###      chef.validation_key_path    = ".chef/chef-validator.pem"
###      chef.run_list               = chef.run_list = [
###          "role[directory]"
###      ]
###    end
###  end
end
