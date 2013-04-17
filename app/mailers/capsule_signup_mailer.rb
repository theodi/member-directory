class CapsuleSignupMailer < ActionMailer::Base
  default from: "richard.stirling@theodi.org"
  default bcc: "members@theodi.org"

  add_template_helper(ApplicationHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.capsule_signup_mailer.confirmation.subject
  #
  def confirmation(member)
    @member = member
    mail to: @member.email
  end
end
