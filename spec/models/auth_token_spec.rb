require_relative "../../app/models/auth_token"

describe AuthToken do

  let(:params) do
    {
      token: "CORRECT"
    }
  end

  subject do
    AuthToken.new(params)
  end

  describe "#valid?" do

    context "token value matches" do
      before do
        ENV["MAILCHIMP_WEBHOOK_TOKEN"] = "CORRECT"
      end

      it "is valid" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "token value does not match" do
      before do
        ENV["MAILCHIMP_WEBHOOK_TOKEN"] = "INCORRECT"
      end

      it "is invalid" do
        expect(subject.invalid?).to eq(true)
      end
    end
  end

  describe "#auth_token" do

    context "missing ENV variable" do
      before do
        ENV.delete("MAILCHIMP_WEBHOOK_TOKEN")
      end

      it "raises an exception" do
        expect { subject.auth_token }.to raise_error(
          ArgumentError, "MAILCHIMP_WEBHOOK_TOKEN is missing"
        )
      end
    end

    context "ENV is available" do
      before do
        ENV["MAILCHIMP_WEBHOOK_TOKEN"] = "YAY! I AM HERE"
      end

      it "returns the value" do
        expect(subject.auth_token).to eq("YAY! I AM HERE")
      end
    end
  end
end

