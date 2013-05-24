class DeviseMailer < Devise::Mailer
  
  def headers_for(action, opts)
    headers = super
    if action == :confirmation_instructions
      headers[:bcc] = 'members@theodi.org'
    end
    headers
  end

end