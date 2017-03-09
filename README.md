# Member Directory 

[![Build Status](http://img.shields.io/travis/theodi/member-directory.svg?style=flat-square)](https://travis-ci.org/theodi/member-directory)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/member-directory.svg?style=flat-square)](https://gemnasium.com/theodi/member-directory)
[![Coverage Status](http://img.shields.io/coveralls/theodi/member-directory.svg?style=flat-square)](https://coveralls.io/github/theodi/member-directory)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/member-directory.svg?style=flat-square)](https://codeclimate.com/github/theodi/member-directory)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://theodi.mit-license.org)

The ODI's member directory frontend application. 

## License

This code is open source under the MIT license. See the LICENSE.md file for 
full details.

## Setup

You need to set various environment variables to tell the app where to post
jobs for background queueing. Copy env.example to .env and edit to fit your
purposes.

## Testing

### Administration

We're using Google's OAuth2 service to authenticate admin users. You need to
have an **@theodi.org** email address in order to gain access.

Locally, you will need to set the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`
environment variables.  The details of which can be obtained from
https://console.developers.google.com.

See https://github.com/zquestz/omniauth-google-oauth2#google-api-setup for more
details.

### Emails

If you want to test email, you can run ```mailcatcher``` before you start the
app in development mode. Mail will then be delivered to a preview window
running at http://localhost:1080.

### Payments

You'll need [ngrok](https://ngrok.com/) (or similar) to test payments through
the stack. This allows you to expose your development server to the Internet so
that Chargify can redirect back and send web hook notifications.

Once you have `ngrok` setup (ask for the credentials), you can setup a tunnel
to your local server like this:

    ngrok http -subdomain member-directory 3000

Which will then be available at:

    http://member-directory.ngrok.io

This URL should already be setup on Chargify but if it isn't follow these steps
to set it up.

Under **Settings -> Webhooks**

Change the web hook URL to be `http://member-directory.ngrok.io/members/chargify_verify`

Under **Setup -> Public Signup Pages -> Edit**

Edit each product and change "Return URL after successful account update" to
`http://member-directory.ngrok.io/members/chargify_return`

More in-depth information is available in [doc/charify.md](doc/charify.md).

### Reports

You can run reports (Booking Value, Cash) manually from within a console
session. There is a `.save_csvs` class method which allows you to save the CSVs
to the filesystem.

    bundle exec rails r "ChargifyReportGenerator.save_csvs"

If you need to run for other months, alter the `previous_month` to refer to the
month you need.

### Tests

The tests are made up of Cucumber features and RSpec specs.

You can run everything at once using `bundle exec rake`.

Or, you can run each suite individually with `bundle exec cucumber` or `bundle
exec rspec`.

## Jobs

The `SyncCapsuleData` (from [open-orgn-services](https://github.com/theodi/open-orgn-services))
is run within this application to take advantage of the Member model.

You can start Resque like this:

    bundle exec rake resque:work VVERBOSE=1 TERM_CHILD=1 QUEUE=directory

Or use Foreman with the supplied `Procfile`.

## Vagrant

In order to run this in a production-alike Vagrant instance, you will first
need to place the ```chef-validator.pem``` file into ```.chef/```, then you can

    vagrant up
    vagrant ssh
    cd members/
    bundle --without production
    rake db:migrate
    rails server

then point your browser at [http://33.33.33.33:3000/]()

This all presumes you have VirtualBox installed, of course.

## Colophon

Social Media icons courtesy of https://github.com/paulrobertlloyd/socialmediaicons/.
Other icons use FontAwesome: http://fortawesome.github.com/Font-Awesome/

