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

  def greeting(resource)
    if @resource.try(:student?) && @resource.student?
      "Dear #{@resource.first_name}"
    else
      if @resource.try(:contact_name) && @resource.individual?
        "Hi #{@resource.first_name}"
      elsif @resource.try(:contact_name)
        "Dear #{@resource.contact_name}"
      else
        "Good #{time_of_day}"
      end
    end
  end

  def indefinite_article(phrase)
    if phrase =~ /^[aeiou]/i
      "an #{phrase}"
    else
      "a #{phrase}"
    end
  end

  def date_months
    (1..12).map do |month|
      [Date::MONTHNAMES[month], "%.2d" % month]
    end
  end

  def course_date_years(years_before = 5, years_after = 5)
    current_year = Time.now.year
    to           = current_year + years_after
    from         = current_year - years_before

    (from..to).to_a
  end
end
