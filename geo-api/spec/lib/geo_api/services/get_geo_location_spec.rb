require "rails_helper"

RSpec.describe GeoApi::Services::GetGeoLocation do
  describe "#call" do
    let(:lookup_value) { "127.0.0.1" }
    let!(:geo_lookup) { FactoryBot.create(:geo_lookup, ip: lookup_value) }
    let!(:geo_location) { FactoryBot.create(:geo_location, geo_lookup: geo_lookup) }

    subject(:service_call) { described_class.new.call(lookup_value: lookup_value) }

    context "on success" do
      context "when ipv4 is provided" do
        it "returns geo location record" do
          expect(service_call).to eql(geo_location)
        end
      end # context "when ipv4 is provided"

      context "when ipv6 is provided" do
        let(:lookup_value) { "2001:0000:130F:0000:0000:09C0:876A:130B" }

        it "returns geo location record" do
          expect(service_call).to eql(geo_location)
        end
      end # context "when ipv6 is provided"

      context "when url is provided" do
        let(:lookup_value) { "https://github.com/" }
        let!(:geo_lookup) { FactoryBot.create(:geo_lookup, hostname: lookup_value) }

        it "returns geo location record" do
          expect(service_call).to eql(geo_location)
        end
      end # context "when url is provided"
    end # context "on success"

    context "on error" do
      context "when lookup value is invalid" do
        let(:lookup_value) { "boom!" }

        it "raises error" do
          expect { service_call }.to raise_error(StandardError, described_class::ERROR_MSG_INVALID_LOOKUP_VALUE % lookup_value)
        end
      end # context "when lookup value is invalid"

      context "when record doesn't exist" do
        let!(:geo_lookup) { FactoryBot.create(:geo_lookup, ip: "2001:0000:130F:0000:0000:09C0:876A:130B") }

        it "raises error" do
          expect { service_call }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end # context "when record doesn't exist"
    end # context "on error"
  end # describe "#call"
end