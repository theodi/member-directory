When /^I leave (\w*) blank$/ do |field|
  fill_in("#{@field_prefix}_#{field}", :with => nil)
end
