Then /^(I|they) should see "(.*?)"$/ do |ignore, text|
  expect(page).to have_content(text)
end
