class UnsubscribeFromNewsletter
  Unauthorized = Class.new(StandardError)

  attr_writer :model
  attr_reader :params, :auth_token

  def initialize(params, auth_token = AuthToken.new(params))
    @params     = params
    @auth_token = auth_token
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
    raise Unauthorized if auth_token.invalid?
  end

  def model
    @model ||= Member
  end
end

