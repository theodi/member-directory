# encoding: utf-8
class DeviseMailer < Devise::Mailer

  add_template_helper(ApplicationHelper)

  def headers_for(action, opts)
    headers = super
    headers['X-MC-Subaccount'] = 'directory'
    if action == :confirmation_instructions
      headers[:bcc] = 'members@theodi.org'
    end

    headers
  end

  def confirmation_instructions(record, opts)
    @type = "capsule" if record.remote?

    attachments.inline['email.jpg'] = {
      mime_type: 'image/jpg',
      content: File.read(Rails.root.join('public/email.jpg'))
    }

    super
  end
end
