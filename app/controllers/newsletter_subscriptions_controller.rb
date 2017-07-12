class NewsletterSubscriptionsController < ApplicationController
  rescue_from UnsubscribeFromNewsletter::Unauthorized, :with => :unauthorized

  def unsubscribe
    UnsubscribeFromNewsletter.new(params).unsubscribe
    render nothing: true, status: 200
  end

  private

  def unauthorized
    render nothing: true, status: 401
  end
end

