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

  describe "#course_date_months" do
    it "should return the years" do
      Timecop.freeze(Time.local(2015, 1, 1, 1, 0, 0)) do
        expect(helper.course_date_years(5, 5)).to eq(
          [
            2010,
            2011,
            2012,
            2013,
            2014,
            2015,
            2016,
            2017,
            2018,
            2019,
            2020
          ]
        )
      end
    end
  end

  describe "#date_months" do
    it "should return the months" do
      expect(helper.date_months).to eq(
        [
          ["January",   "01"],
          ["February",  "02"],
          ["March",     "03"],
          ["April",     "04"],
          ["May",       "05"],
          ["June",      "06"],
          ["July",      "07"],
          ["August",    "08"],
          ["September", "09"],
          ["October",   "10"],
          ["November",  "11"],
          ["December",  "12"]
        ]
      )
    end
  end
end
