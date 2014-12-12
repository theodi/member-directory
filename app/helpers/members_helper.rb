module MembersHelper

  def organization_description(organization)
    # First, try to split out first paragraph
    summary = organization.description.split("\n").first
    # Now truncate if necessary
    truncate(summary, :length => 300, :separator => " ", :omission => " ...")
  end

  def get_colour(colour)
    {
      'black' => '#000',
      'blue' => '#00b7ff',
      'red' => '#ff6700',
      'crimson' => '#d30102',
      'orange' => '#f99C06',
      'green' => '#0DBC37',
      'pomegranate' => '#dc4810',
      'grey' => '#aaa',
      'orange' => '#ff6700'
    }[colour] rescue nil
  end

  def member_colour(member)
    member_colours[member.product_name]
  end

  def member_colours
    {
      'partner' => 'blue',
      'sponsor' => 'green',
      'supporter' => 'orange',
    }
  end

  def pagination_item(content, active)
    content_tag(:li, content, class: ('active' if active))
  end

end
