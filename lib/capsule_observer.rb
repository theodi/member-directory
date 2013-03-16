class CapsuleObserver
  
  def self.register
    SyncCapsuleData.add_observer(self)
  end
  
  # Receives data updates from CapsuleCRM
  # 
  # data -  hash of data  from CapsuleCRM
  #         active        => Whether the membership is active or not (will be shown in the public directory)
  #         email         => The contact email for the membership
  #         name          => The organization name
  #         description   => The organization description
  #         url           => The organization's homepage
  #         product_name  => The membership level
  #         membership_id => The membership ID (if this is nil, it must be a new member)
  #
  def self.update(data)
    # Is there a membership ID?
    # If so, update the data in the appropriate member
    # If not, create a new member with the synced data
    # When we are creating a new member, we need to look at what it queues up; we don't want
    # to send an invoice, for instance. We will probably have to rewrite some of the member#after_create 
    # stuff.
  end
  
end

CapsuleObserver.register