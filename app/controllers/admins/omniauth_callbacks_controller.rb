class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    @admin = Admin.find_for_googleapps_oauth(request.env["omniauth.auth"], current_admin)

    if @admin.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "GoogleApps"
      sign_in_and_redirect @admin, :event => :authentication
    else
      redirect_to new_member_registration_url
    end
  end
end