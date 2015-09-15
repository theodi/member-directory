class UnsubscribeFromNewsletter
  attr_writer :model
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def unsubscribe
    member = model.where(email: params[:data][:email]).first
    member.update_attribute(:cached_newsletter, false)
  end

  private

  def model
    @model ||= Member
  end
end

