When /^I leave (\w*) blank$/ do |field|
  if %w[organization_size organization_type organization_sector address_country].include?(field)
    select("Please select", :from => "#{@field_prefix}_#{field}")
  else
    fill_in("#{@field_prefix}_#{field}", :with => nil)
  end
end
