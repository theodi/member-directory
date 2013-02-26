module DeviseHelper

  def devise_error_messages!
    if resource.errors.empty?
      ''
    else
      messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      html = <<-HTML
        <div class="alert alert-error">
          <ul class='unstyled'>#{messages}</ul>
        </div>
      HTML
      html.html_safe
    end
  end

end
