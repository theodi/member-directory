require 'resque/tasks'
require 'resque/failure/airbrake'

namespace :resque do
  task :setup => :environment do
    if ENV['AIRBRAKE_API_KEY']
      Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
      Resque::Failure.backend = Resque::Failure::Multiple
    end
  end
end