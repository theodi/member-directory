# Create organizations for existing Members
Member.includes(:organization).where('organizations.id IS NULL').each do |m|
  # Use send as setup_organization is private
  m.send(:setup_organization)
end