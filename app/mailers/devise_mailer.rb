class DeviseMailer < Devise::Mailer
  
  add_template_helper(ApplicationHelper)

  def headers_for(action, opts)
    headers = super
    if action == :confirmation_instructions
      headers[:bcc] = 'members@theodi.org'
    end
    headers
  end

end