require_relative "../../app/models/update_directory_entry"

SendDirectoryEntryToCapsule = Class.new unless defined?(SendDirectoryEntryToCapsule)

describe UpdateDirectoryEntry do

  subject do
    UpdateDirectoryEntry.new(organization, queue)
  end

  let(:member) do
    double(
      "Member",
      :membership_number => "12345",
      :cached_active     => true
    )
  end

  let(:logo) do
    double(
      "Logo",
      :url => "http://path/to/image",
      :square => double(
        :url => "http://path/to/square/image"
      )
    )
  end

  let(:organization) do
    double(
      "Organization",
      :name                 => "Test Organization",
      :description          => "Organization description",
      :url                  => "http://test.example.com",
      :logo                 => logo,
      :cached_contact_name  => "Test contact",
      :cached_contact_phone => "01234 567890",
      :cached_contact_email => "test@example.com",
      :cached_twitter       => "@testexample",
      :cached_linkedin      => "linkedin",
      :cached_facebook      => "facebook",
      :cached_tagline       => "We are the best!",
      :updated_at           => Time.new(2015, 8, 28, 12, 35, 0, "+01:00"),
      :member               => member
    )
  end

  let(:queue) { double("Job Queue") }

  describe "#update!" do
    it "queues a job to send to Capsule" do

      expected_membership_number = "12345"

      expected_organization_name = {
        :name => "Test Organization"
      }

      expected_directory_entry = {
        :active      => true,
        :description => "Organization description",
        :homepage    => "http://test.example.com",
        :logo        => "http://path/to/image",
        :thumbnail   => "http://path/to/square/image",
        :contact     => "Test contact",
        :phone       => "01234 567890",
        :email       => "test@example.com",
        :twitter     => "@testexample",
        :linkedin    => "linkedin",
        :facebook    => "facebook",
        :tagline     => "We are the best!"
      }

      expected_update_date = "2015-08-28 12:35:00 +0100"

      expect(queue).to receive(:enqueue).with(
        SendDirectoryEntryToCapsule,
        expected_membership_number,
        expected_organization_name,
        expected_directory_entry,
        expected_update_date
      )

      subject.update!
    end
  end
end

