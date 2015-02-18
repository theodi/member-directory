class ChargifySubscriptionWorker
  @queue = :directory

  def self.perform(member_id, attributes)
    member = Member.find(member_id)
    new.create_invoice_subscription(member, attributes)
  end

  def create_invoice_subscription(member, attributes)
    fname, lname = extract_name_pair(attributes['contact_name'])
    subscription = Chargify::Subscription.create(
      :product_handle => member.chargify_product_handle,
      :customer_attributes => {
        :first_name => fname,
        :last_name => lname,
        :email => member.email,
        :organization => member.organization.name,
        :reference => member.membership_number,
        :address => attributes['street_address'],
        :address_2 => attributes['address_locality'],
        :city => attributes['address_region'],
        :country => attributes['address_country'],
        :zip => attributes['postal_code']
      },
      :payment_collection_method => 'invoice',
      :vat_number => attributes['vat_id'],
      :agreement_terms => true)
    member.update_attribute(:chargify_subscription_id, subscription.id)
    member.update_attribute(:chargify_customer_id, subscription.customer.id)
  end

  def extract_name_pair(contact_name)
    contact_name.strip.split(/\s+/, 2)
  end
end
