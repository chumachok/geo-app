require "rails_helper"

RSpec.describe GeoApi::Services::GetRemoteGeoLocation do
  describe "#call" do
    let(:lookup_value) { "127.0.0.1" }
    let(:ip_lookup_return) do
      {
        ip: lookup_value,
      }
    end
    let(:hostname_lookup_return) do
      {
        hotname: lookup_value,
      }
    end
    let(:client) { double("client_class", ip_lookup: ip_lookup_return, hostname_lookup: hostname_lookup_return) }
    subject(:service_call) do
      described_class.new.call(client: client, lookup_value: lookup_value)
    end

    context "on success" do
      context "when lookup value is ip" do
        it "returns ip_lookup return" do
          expect(service_call).to eql(ip_lookup_return)
        end
      end

      context "when lookup value is url" do
        let(:lookup_value) { "https://github.com" }

        it "returns hotname_lookup return" do
          expect(service_call).to eql(hostname_lookup_return)
        end
      end
    end # context "on success"

    context "on error" do
      context "when lookup value is invalid" do
        let(:lookup_value) { "boom!" }

        it "raises an error" do
          expect { service_call }.to raise_error(
            StandardError, described_class::ERROR_MESSAGE_INVALID_LOOKUP_VALUE % lookup_value
          )
        end
      end # context "when lookup value is invalid"

      context "when client raises an error" do
        let(:error) { "boom!" }

        before do
          allow(client).to receive(:ip_lookup).and_raise(error)
        end

        it "propagates raised error" do
          expect { service_call }.to raise_error(error)
        end
      end # context "when client raises an error"
    end # context "on error"
  end # describe "#call"
end