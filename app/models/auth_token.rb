class AuthToken
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def invalid?
    !valid?
  end

  def valid?
    params[:token] == auth_token
  end

  def auth_token
    ENV.fetch("MAILCHIMP_WEBHOOK_TOKEN") do
      raise ArgumentError, "MAILCHIMP_WEBHOOK_TOKEN is missing"
    end
  end
end

