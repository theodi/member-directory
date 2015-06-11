class DeviseMailer < Devise::Mailer

  add_template_helper(ApplicationHelper)

  def headers_for(action, opts)
    headers = super
    if action == :confirmation_instructions
      headers[:bcc] = 'members@theodi.org'
    end
    headers
  end

  def confirmation_instructions(record, opts)
    @type = "capsule" if opts[:capsule].present?
    if record.individual?
      document_renderer = DocumentRenderer.new
      attachments.inline['supporter.png'] = {
        mime_type: 'image/png',
        content: File.read(Rails.root.join('public/supporter.png'))
      }
      attachments['terms-and-conditions.html'] = {
        mime_type: 'text/html',
        content: document_renderer.terms_and_conditions(record)
      }
    end
    super
  end

end
