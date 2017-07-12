RailsAdmin.config do |config|

  config.main_app_name = ['Member Directory', 'Admin']

  config.current_user_method { current_admin }

  config.included_models = ['Member']

end
