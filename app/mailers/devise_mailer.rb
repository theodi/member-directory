class DeviseMailer < Devise::Mailer

  def headers_for(action, opts)
    headers = super
    if action == 'confirmation'
      headers = headers.merge({
        :bcc => 'members@theodi.org'
      })
    end
    headers
  end

end