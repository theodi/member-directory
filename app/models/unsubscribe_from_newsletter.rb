class UnsubscribeFromNewsletter
  attr_writer :model
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def unsubscribe
    member.unsubscribe_from_newsletter!
  end

  def member
    model.where(email: member_email).first
  end

  private

  def member_email
    params[:data][:email]
  end

  def model
    @model ||= Member
  end
end

