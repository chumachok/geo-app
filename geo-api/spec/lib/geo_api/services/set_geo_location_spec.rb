require "rails_helper"

RSpec.describe GeoApi::Services::SetGeoLocation do
  describe "#call" do
    let(:lookup_client_type) { GeoLookup::LOOKUP_CLIENT_IPSTACK }
    let(:lookup_client) { double("client", type: lookup_client_type) }
    let(:hostname1) { "cats.com" }
    let(:hostname2) { "birds.com" }
    let(:ip) { "127.0.0.1" }
    let(:lookup_value) { ip }

    let(:continent_code) { "continent_code" }
    let(:continent_name) { "continent_name" }
    let(:country_code) { "country_code" }
    let(:country_name) { "country_name" }
    let(:region_code) { "region_code" }
    let(:region_name) { "region_name" }
    let(:city) { "city" }
    let(:zip_code) { Faker::Address.zip }
    let(:latitude) { -0.401064e0 }
    let(:longitude) { 0.5837876e2 }

    let(:get_remote_geo_location_return) do
      {
        ip: ip,
        hostname: hostname1,
        continent_code: continent_code,
        continent_name: continent_name,
        country_code: country_code,
        country_name: country_name,
        region_code: region_code,
        region_name: region_name,
        city: city,
        zip: zip_code,
        latitude: latitude,
        longitude: longitude,
      }
    end
    let(:get_remote_geo_location_class) { class_double(GeoApi::Services::GetRemoteGeoLocation).as_stubbed_const }
    let(:get_remote_geo_location_instance) { instance_double(get_remote_geo_location_class, call: get_remote_geo_location_return) }
    subject(:service_call) do
      described_class.new.call(
        lookup_client: lookup_client,
        lookup_value: lookup_value,
      )
    end

    before do
      allow(get_remote_geo_location_class).to receive(:new).and_return(get_remote_geo_location_instance)
    end

    context "on success" do
      context "when geo location record exists" do
        let!(:geo_lookup) { FactoryBot.create(:geo_lookup, ip: lookup_value) }
        let!(:geo_location) { FactoryBot.create(:geo_location, geo_lookup: geo_lookup) }

        it "updates existing geo lookup record with remote details" do
          service_call
          expect(geo_lookup.reload).to match(an_object_having_attributes(
            ip: lookup_value,
            hostname: hostname1,
            lookup_client: lookup_client_type,
          ))
        end

        it "updates existing geo location record with remote details" do
          service_call
          expect(geo_location.reload).to match(an_object_having_attributes(
            continent_code: continent_code,
            continent_name: continent_name,
            country_code: country_code,
            country_name: country_name,
            region_code: region_code,
            region_name: region_name,
            city: city,
            zip_code: zip_code,
            latitude: latitude,
            longitude: longitude,
            geo_lookup_id: geo_lookup.id,
          ))
        end

        it "does NOT create new geo location records" do
          expect { service_call }.to_not change{ GeoLocation.count }
        end

        it "returns geo location" do
          expect(service_call).to eql(geo_location)
        end
      end # context "when geo location record exists"

      context "when location record does NOT exist" do
        it "creates a new geo location record" do
          expect { service_call }.to change{ GeoLookup.count }.by(1)
        end

        it "creates a new geo location record" do
          expect { service_call }.to change{ GeoLocation.count }.by(1)
        end

        it "returns geo location" do
          expect(service_call).to eql(GeoLocation.last)
        end

        describe "new geo lookup record" do
          it "has correct attributes" do
            service_call
            expect(GeoLookup.last).to match(an_object_having_attributes(
              ip: lookup_value,
              hostname: hostname1,
              lookup_client: lookup_client_type,
            ))
          end
        end # describe "new geo lookup record"

        describe "new geo location record" do
          it "has correct attributes" do
            service_call
            expect(GeoLocation.last).to match(an_object_having_attributes(
              continent_code: continent_code,
              continent_name: continent_name,
              country_code: country_code,
              country_name: country_name,
              region_code: region_code,
              region_name: region_name,
              city: city,
              zip_code: zip_code,
              latitude: latitude,
              longitude: longitude,
              geo_lookup_id: GeoLookup.last.id,
            ))
          end
        end # describe "new geo location record"
      end # context "when location record does NOT exist"

      context "when other geo location records had the hostname" do
        let(:lookup_value) { "https://#{hostname1}" }
        let!(:geo_lookup1) { FactoryBot.create(:geo_lookup, ip: ip, hostname: nil) }
        let!(:geo_location1) { FactoryBot.create(:geo_location, geo_lookup: geo_lookup1) }
        let!(:geo_lookup2) { FactoryBot.create(:geo_lookup, hostname: hostname1) }
        let!(:geo_location2) { FactoryBot.create(:geo_location, geo_lookup: geo_lookup2) }

        it "updates outdated hostname values to nil" do
          service_call
          expect(geo_lookup2.reload.hostname).to eql(nil)
        end

        it "updates geo lookup hostname value to client's return" do
          service_call
          expect(geo_lookup1.reload.hostname).to eql(hostname1)
        end

      end # context "when other geo location records had the hostname"
    end # context "on success"
  end # describe "#call"
end