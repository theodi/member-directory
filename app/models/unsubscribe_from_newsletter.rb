class UnsubscribeFromNewsletter
  Unauthorized = Class.new(StandardError)

  attr_writer :model
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def unsubscribe
    authorize!

    member.unsubscribe_from_newsletter!
  end

  def member
    model.where(email: member_email).first
  end

  private

  def member_email
    params[:data][:email]
  end

  def authorize!
    raise Unauthorized if !authorized?
  end

  def authorized?
    params[:token] == auth_token
  end

  def auth_token
    ENV.fetch("MAILCHIMP_WEBHOOK_TOKEN") do
      raise ArgumentError, "MAILCHIMP_WEBHOOK_TOKEN is missing"
    end
  end

  def model
    @model ||= Member
  end
end

