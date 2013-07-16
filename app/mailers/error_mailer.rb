class ErrorMailer < ActionMailer::Base
  default from: "richard.stirling@theodi.org"
  default to: "members@theodi.org"

  add_template_helper(ApplicationHelper)

  def membership_number_generation_failed(capsule_id)
    @capsule_id = capsule_id
    @link = "http://#{ ENV['CAPSULECRM_ACCOUNT_NAME'] }.capsulecrm.com/party/#{ @capsule_id }"
    mail
  end
end
