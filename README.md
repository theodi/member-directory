Member Directory
================

[![Build Status](http://jenkins.theodi.org/job/member-directory-build-master/badge/icon)](http://jenkins.theodi.org/job/member-directory-build-master/)
[![Dependency Status](https://gemnasium.com/theodi/member-directory.png)](https://gemnasium.com/theodi/member-directory)
[![Code Climate](https://codeclimate.com/github/theodi/member-directory.png)](https://codeclimate.com/github/theodi/member-directory)


The ODI's member directory frontend application. 

License
-------

This code is open source under the MIT license. See the LICENSE.md file for 
full details.

Setup
-----

You need to set various environment variables to tell the app where to post jobs for background queueing. Copy env.example to .env and edit to fit your purposes.

Testing Emails
--------------

If you want to test email, you can run ```mailcatcher``` before you start the app in development mode. Mail will then be delivered to a preview window running at http://localhost:1080.

Vagrant
-------

In order to run this in a production-alike Vagrant instance, you will first need to place the ```chef-validator.pem``` file into ```.chef/```, then you can

    vagrant up
    vagrant ssh
    cd members/
    bundle --without production
    rake db:migrate
    rails server

then point your browser at [http://33.33.33.33:3000/]()

This all presumes you have VirtualBox installed, of course.

Colophon
--------

Social Media icons courtesy of https://github.com/paulrobertlloyd/socialmediaicons/.
Other icons use FontAwesome: http://fortawesome.github.com/Font-Awesome/
