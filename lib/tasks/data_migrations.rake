namespace :data do
  
  # This task runs data migrations.
  # Data migrations are specified in timestamped files in db/data_migrations
  # All of these will be run every time, in timestamp order, so they should be idempotent
  
  desc ('Run data migrations (generally run after database migrations)')
  task :migrate => :environment do
    
      Dir.glob("#{Rails.root}/db/data_migrations/*.rb").each do |migration_file|
        require migration_file
      end
    
  end
  
end