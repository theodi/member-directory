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
    cd ~/.vagrant.d/gems/gems/
    VR=`ls | grep vagrant-rackspace`
    rm -fr ${VR}
    git clone https://github.com/theodi/vagrant-rackspace ${VR}
    
That's really ugly, sorry. The price we pay for being on the cutting-edge, or something.

So, we now need some credentials.