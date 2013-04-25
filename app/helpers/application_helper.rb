module ApplicationHelper

  def error_messages(obj)
    if obj.errors.empty?
      ''
    else
      messages = obj.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      html = <<-HTML
        <div class="alert alert-error">
          <ul class='unstyled'>#{messages}</ul>
        </div>
      HTML
      html.html_safe
    end
  end

  def form_field(f, field, &block)
    content_tag :div, :class => 'control-group' do
      f.label(field, :class => 'control-label') + content_tag(:div, :class => 'controls', &block)
    end
  end

  def time_of_day
    case Time.now.localtime.hour
    when 0..11
      "morning"
    when 18..23
      "evening"
    else
      "afternoon"
    end
  end

  def alternate_url(new_params)
    url_for params.merge(new_params)
  end
  
  def alternate_button(format)
    icons = {
      json: 'icon-list'
    }
    format_translation = t("formats.#{format}")
    link_to "<i class='#{icons[format]}'></i> #{format_translation}".html_safe, 
        alternate_url(:format => format), 
        :rel => 'alternate', 
        :type => Mime::EXTENSION_LOOKUP[format.to_s].to_s,
        :class => "btn",
        :title => "Get this in #{format_translation} format"
  end
  
end