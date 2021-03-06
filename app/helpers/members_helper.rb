module MembersHelper

  def listing_summary(member)
    if member.organization_description
      # First, try to split out first paragraph
      summary = member.organization_description.split("\n").first
      # Now truncate if necessary
      truncate(summary, :length => 300, :separator => " ", :omission => " ...")
    else
      ""
    end
  end

  def highlight(text, search)
    return if text.nil?
    super(text, search, :highlighter => '<mark>\1</mark>')
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
    }[colour] rescue nil
  end

  def badge_colours(member)
    (%w[black grey] + [member_colour(member)]).compact
  end

  def member_colour(member)
    {
      'partner' => 'blue',
      'sponsor' => 'green',
      'supporter' => 'orange',
    }[member.product_name]
  end

  def badge_download_colours(member)
    if member_colour(member) == 'orange'
      %w[black grey orange]
    else
      %w[black grey]
    end
  end

  def pagination_item(content, active)
    content_tag(:li, content, class: ('active' if active))
  end

  def field_visibility(field)
    unless params[:member] && params[:member][field] == "Other (please specify)"
      'style="display: none"'.html_safe
    end
  end
end
