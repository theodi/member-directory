require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the MembersHelper. For example:
#
# describe MembersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe MembersHelper do
  describe "#payment_button_label" do
    let(:member) { double(student?: false) }

    context "type if free" do
      it "asks you to enter your card details" do
        discount_type = :free

        expect(helper.payment_button_label(member, discount_type)).to eq("Enter card details")
      end
    end

    context "type is not free" do
      it "asks you to pay now" do
        discount_type = :not_free

        expect(helper.payment_button_label(member, discount_type)).to eq("Pay now")
      end
    end

    context "the member is a student?" do
      let(:member) { double(student?: true) }

      it "asks you to 'Complete' the process" do
        discount_type = :anything

        expect(helper.payment_button_label(member, discount_type)).to eq("Complete")
      end
    end
  end
end

