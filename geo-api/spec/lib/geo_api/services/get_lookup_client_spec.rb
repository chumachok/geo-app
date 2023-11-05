require "rails_helper"

RSpec.describe GeoApi::Services::GetLookupClient do
  describe "#call" do
    let(:lookup_client) { "ipstack" }
    subject(:service_call) do
      described_class.new.call
    end

    before do
      allow(Rails.application.credentials).to receive(:[]).with(:lookup_client).and_return(lookup_client)
      allow(Rails.application.credentials).to receive(:[]).with(:ipstack_access_key).and_return("some_key")
    end

    context "on success" do
      context "when client is supported" do

        it "returns client" do
          expect(service_call).to be_an_instance_of(GeoApi::Clients::Ipstack)
        end
      end # context "when client is supported"
    end # context "on success"

    context "on error" do
      context "when client is NOT supported" do
        let(:lookup_client) { "wrong_client" }

        it "raises an error" do
          expect { service_call }.to raise_error(
            StandardError, described_class::ERROR_MESSAGE_UNSUPPORTED_LOOKUP_CLIENT % lookup_client
          )
        end
      end # context "when client is NOT supported"
    end # context "on error"
  end # describe "#call"
end