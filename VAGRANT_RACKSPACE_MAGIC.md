# Magic Space Future
We can spin these things up into Rackspace with Vagrant 1.1. This is awesome. However there are still a couple of rough edges:

## Install Vagrant 1.1
It's now recommended to use the packages, not the gem. Get 'em [here](http://downloads.vagrantup.com/).

## Install the vagrant-rackspace plugin
The current vagrant-rackspace plugin does not let us specify an _auth_url_, so it won't work for the London DC. We have [a fork](https://github.com/theodi/vagrant-rackspace) which does understand this, but until either

* our PR is accepted into the project, or
* the plugin system lets us specify a Github repo as a plugin source

we have to hackity-hack. So:

    vagrant plugin install vagrant-rackspace
    pushd ~/.vagrant.d/gems/gems/
    VR=`ls | grep vagrant-rackspace`
    rm -fr ${VR}
    git clone https://github.com/theodi/vagrant-rackspace ${VR}
    popd

That's really ugly, sorry. The price we pay for being on the cutting-edge, or something.

## Authentication
So, we now need some credentials. These files:
    
    .chef/chef-validator.pem
    .chef/odi.pem
    .chef/rackspace_secrets.yaml

you can get from Sam. (I think they might belong in the password file, opinions welcome). You'll also want to do

    ssh-keygen -f .chef/id_rsa
    
to generate a keypair which will be used to login to this box and configure the chef-client - seeing as these things are now in the hands of Chef, we should only ever need to connect to them once (and this will be even more true when we've got Logstash running).

## Punch it, Chewie
We're now in a position to fire up a node!

    vagrant up directory_theodi_org_01 --provider rackspace
    
This _should_ spin up a node and provision it

## Next steps
* Solve problem of different logins for Rackspace and VirtualBox
* Somehow loop so we can call 'vagrant up -x 2' or something
* Magically attach to load-balancer