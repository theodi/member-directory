class AddCouponToMember < ActiveRecord::Migration
  def change
    add_column :members, :coupon, :string
  end
end
