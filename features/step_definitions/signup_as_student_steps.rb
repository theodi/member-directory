Given(/^I want to sign up as an student member$/) do
  @product_name = 'student'
  @payment_method = 'credit_card'
  @payment_ref = /cus_[0-9A-Za-z]{14}/
end

Then(/^I should not be asked for organization details$/) do
  steps %{
    Then I should not see the "Organisation Name" field
    And I should not see the "Organisation size" field
    And I should not see the "Organisation type" field
    And I should not see the "Industry sector" field
    And I should not see the "Company Number" field
  }
end

Then(/^I should not be asked for financial information$/) do
  steps %{
    And I should not see the "VAT Number (if not UK)" field
    And I should not see the "Purchase Order Number" field
  }
end

