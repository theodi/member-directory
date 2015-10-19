When(/^I request a password reset$/) do
  visit '/'
  first(:link, "Sign in").click
  click_link 'Forgot your password?'
  fill_in 'member_email', with: @membership.email
  click_button 'Send me reset password instructions'
end

Then(/^I should receive a password reset email$/) do
  steps %Q(
    Then "#{@membership.email}" should receive an email with subject "Password reset instructions"
    When I open the email with subject "Password reset instructions"
    Then I should see "Someone has requested a link to change your password." in the email body
    And I should see the email delivered from "members@theodi.org"
  )
end

Then(/^I should be able to change my password$/) do
  steps %Q(
    When I click the first link in the email
    Then I should see "Set your password"
  )
  @new_password = 'nyarlathotep'
  fill_in 'member_password', with: @new_password
  fill_in 'member_password_confirmation', with: @new_password
  click_button 'Change my password'
  steps %Q(
    Then I should see "Your password was changed successfully. You are now signed in."
  )
end
