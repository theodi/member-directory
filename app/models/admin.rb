class Admin < ActiveRecord::Base

  devise :omniauthable, :trackable, :omniauth_providers => [:google_oauth2]

  attr_accessible :email

  def self.find_for_googleapps_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
  
    if admin = Admin.where(:email => data['email']).first 
      return admin
    else #create an admin with stub pwd
      Admin.create!(:email => data['email'])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |admin|
      if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
        admin.email = data['email']
      end
    end
  end
  
end
