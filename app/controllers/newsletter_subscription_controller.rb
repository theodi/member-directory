class NewsletterSubscriptionsController < ApplicationController
  def unsubscribe
    UnsubscribeFromNewsletter.new(params).unsubscribe
    render nothing: true, status: 200
  end
end

