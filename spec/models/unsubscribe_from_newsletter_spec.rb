require_relative "../../app/models/unsubscribe_from_newsletter"

describe UnsubscribeFromNewsletter do

  let(:params) do
    {
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
    }
  end

  subject do
    UnsubscribeFromNewsletter.new(params, auth_token)
  end

  let(:member_model) { double("Member model") }

  let(:member_instance) { double("Member instance") }

  let(:auth_token) { double("Auth Token", invalid?: false) }

  before do
    subject.model = member_model
  end

  describe "#unsubscribe" do

    context "member's email exists" do
      it "should update the member's newsletter preference" do
        allow(member_model).to receive(:where)
          .with(email: "test@example.com")
          .and_return([member_instance])

        expect(member_instance).to receive(:unsubscribe_from_newsletter!)

        subject.unsubscribe
      end
    end

    context "authorization token is bad" do
      it "should raise an exception" do
        allow(auth_token).to receive(:invalid?).and_return(true)

        expect { subject.unsubscribe }.to raise_error(
          UnsubscribeFromNewsletter::Unauthorized
        )
      end
    end

    context "params are missing" do
      let(:params) { {} }

      it "should return false" do
        allow(member_model).to receive(:where)
          .with(email: nil)

        expect(subject.unsubscribe).to eq(false)
      end
    end
  end
end

