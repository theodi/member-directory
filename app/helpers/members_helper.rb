module MembersHelper

  def organization_description(organization)
    # First, try to split out first paragraph
    summary = organization.description.split("\n").first
    # Now truncate if necessary
    truncate(summary, :length => 300, :separator => " ", :omission => " ...")
  end  

end
