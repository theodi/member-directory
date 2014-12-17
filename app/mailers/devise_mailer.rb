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
    if record.individual?
      document_renderer = DocumentRenderer.new
      attachments['terms-and-conditions.html'] = {
        mime_type: 'text/html',
        content: document_renderer.terms_and_conditions(record)
      }
      attachments['data-protection-policy.html'] = {
        mime_type: 'text/html',
        content: document_renderer.data_protection_policy(record)
      }
    end
    super
  end

end
