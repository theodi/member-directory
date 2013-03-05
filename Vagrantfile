# -*- mode: ruby -*-
# vi: set ft=ruby :


# You will need the chef-validator.pem keyfile to make this work, put it in .chef/.
# Then, you should be able to do:
#
# vagrant up
# vagrant ssh
# cd members/
# bundle --without production
# rake db:migrate
# rails server
#
# then point your browser at http://33.33.33.100:3000/

Vagrant::Config.run do |config|

  config.vm.host_name = "members-vagrant"
  config.vm.box       = "precise64"
  config.vm.network :hostonly, "33.33.33.33"

  config.vm.share_folder("members", "/home/vagrant/members", ".")

  config.vm.provision :chef_client do |chef|
    chef.node_name              = "vagrant-%s" % [
        ENV["USER"]
    ]
    chef.environment            = "vagrant"
    chef.chef_server_url        = "https://chef.theodi.org"
    chef.validation_client_name = "chef-validator"
    chef.validation_key_path    = ".chef/chef-validator.pem"
    chef.run_list               = chef.run_list = [
        "role[members]"
    ]
    config.vm.provision :shell do |shell|
      shell.inline = "echo -e \"$1='$2'\n$3='$4'\" > $5"
      shell.args   = "RESQUE_REDIS_HOST localhost RESQUE_REDIS_PORT 6379 /home/vagrant/members/.env"
    end
  end

end