require "spec_helper"

describe ContactRequestsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/contact_requests/new" }.should route_to(:controller => "contact_requests", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/contact_requests" }.should route_to(:controller => "contact_requests", :action => "create")
    end

  end
end
