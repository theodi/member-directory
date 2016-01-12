# encoding: utf-8
class DeviseMailer < Devise::Mailer

  add_template_helper(ApplicationHelper)

  def headers_for(action, opts)
    headers = super
    if action == :confirmation_instructions
      headers[:bcc] = 'members@theodi.org'

      if resource.student?
        headers[:subject] = "You’ve joined our network! Now what?"
      end
    end

    headers
  end

  def confirmation_instructions(record, opts)
    @type = "capsule" if record.remote?
    if record.individual? || record.student?
      document_renderer = DocumentRenderer.new(record)

      if record.student?
        attachments.inline['student-email.jpg'] = {
          mime_type: 'image/jpg',
          content: File.read(Rails.root.join('public/student-email.jpg'))
        }
      end

      attachments.inline['supporter.png'] = {
        mime_type: 'image/png',
        content: File.read(Rails.root.join('public/supporter.png'))
      }
      attachments['terms-and-conditions.html'] = {
        mime_type: 'text/html',
        content: document_renderer.terms_and_conditions
      }
    end

    if !record.individual? || !record.student?
      attachments.inline['email.jpg'] = {
        mime_type: 'image/jpg',
        content: File.read(Rails.root.join('public/email.jpg'))
      }
    end

    super
  end
end

