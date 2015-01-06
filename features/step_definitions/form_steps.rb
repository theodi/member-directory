When /^I leave (\w*) blank$/ do |field|
  if ['organization_size','organization_type', 'organization_sector'].include?(field)
    select("Please select", :from => "#{@field_prefix}_#{field}")
  else
    fill_in("#{@field_prefix}_#{field}", :with => nil)
  end
end
