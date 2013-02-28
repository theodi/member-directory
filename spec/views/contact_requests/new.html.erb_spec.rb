require 'spec_helper'

describe "contact_requests/new.html.erb" do
  it "renders new contact_request form" do
    render
    assert_select "form", :action => contact_requests_path, :method => "post" do
    end
  end
end
