require 'spec_helper'

describe "ContactRequests" do
  describe "GET /contact_requests/new" do
    it "can create new contact request" do
      get new_contact_request_path
    end
  end
end
