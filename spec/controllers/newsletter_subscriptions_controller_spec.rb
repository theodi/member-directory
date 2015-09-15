require 'spec_helper'

describe NewsletterSubscriptionsController do
  describe "POST 'newsletter'" do

    let!(:member) do
      FactoryGirl.create(
        :member,
        :email => "test@example.com",
        :cached_newsletter => true
      )
    end

    it "sets the member's newsletter preference" do
      post :unsubscribe,
        type: "unsubscribe",
        fired_at: "2015-09-15 13:21:27",
        data: {
          action: "unsub",
          reason: "manual",
          id: "0569b7ecd9",
          email: "test@example.com",
          email_type: "html",
          ip_opt: "54.197.99.121",
          web_id: "81114985",
          merges: {
            EMAIL: "test@example.com",
            FNAME: "",
            LNAME: ""
          }
        },
        :list_id => "0faf82f65e"

      expect(response).to have_http_status(200)
      expect(member.reload.cached_newsletter).to eq(false)
    end
  end
end

