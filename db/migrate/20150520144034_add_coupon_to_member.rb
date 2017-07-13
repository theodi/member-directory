class AddCouponToMember < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :coupon, :string
  end
end
