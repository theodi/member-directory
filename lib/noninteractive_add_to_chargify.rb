class NoninteractiveAddToChargify
  @queue = :directory

  def self.perform(member_id)
    member = Member.find(member_id)
    # Adds the member to Chargify
    # Only used for subscriptions that are created noninteractively
    return if member.chargify_subscription_id
    # Get the Chargify details
    ch = ChargifyProductLink.new(member)
    subscription = Chargify::Subscription.create(
      :customer_attributes => ch.customer_attributes,
      :product_handle => ch.product_handle,
      :payment_profile => ch.payment_profile_attributes,
      :coupon_code => member.coupon
    )    
    member.update_chargify_values!(
      customer_id: subscription.customer.id,
      subscription_id: subscription.id
    )
  end
  
end