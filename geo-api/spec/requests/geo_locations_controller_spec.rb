require "rails_helper"

RSpec.describe GeoLocationsController, type: :request do
  let(:headers) do
    {
      "Accept" => "application/json",
    }
  end

  describe "#index" do
    let!(:geo_location1) { FactoryBot.create(:geo_location) }
    let(:geo_lookup1) { geo_location1.geo_lookup }
    let!(:geo_location2) { FactoryBot.create(:geo_location) }
    let(:geo_lookup2) { geo_location2.geo_lookup }
    subject(:request) { get geo_locations_path, headers: headers }

    context "on success" do
      it "returns a list of geo locations" do
        request
        expect(response.parsed_body).to match(
          "data" => [
            {
              "attributes" => {
                "city" => geo_location1.city,
                "continent_code" => geo_location1.continent_code,
                "continent_name" => geo_location1.continent_name,
                "country_name" => geo_location1.country_name,
                "country_code" => geo_location1.country_code,
                "id" => geo_location1.id,
                "latitude" => geo_location1.latitude.to_s,
                "longitude" => geo_location1.longitude.to_s,
                "region_code" => geo_location1.region_code,
                "region_name" => geo_location1.region_name,
                "zip_code" => geo_location1.zip_code,
                "ip" => geo_lookup1.ip,
                "hostname" => geo_lookup1.hostname,
              },
              "relationships" => {
                "geo_lookup" => {
                  "data" => {
                    "id" => geo_lookup1.id.to_s,
                    "type" => geo_lookup1.class.name.underscore
                  }
                }
              },
              "id" => geo_location1.id.to_s,
              "type" => geo_location1.class.name.underscore,
            },
            {
              "attributes" => {
                "city" => geo_location2.city,
                "continent_code" => geo_location2.continent_code,
                "continent_name" => geo_location2.continent_name,
                "country_name" => geo_location2.country_name,
                "country_code" => geo_location2.country_code,
                "id" => geo_location2.id,
                "latitude" => geo_location2.latitude.to_s,
                "longitude" => geo_location2.longitude.to_s,
                "region_code" => geo_location2.region_code,
                "region_name" => geo_location2.region_name,
                "zip_code" => geo_location2.zip_code,
                "ip" => geo_lookup2.ip,
                "hostname" => geo_lookup2.hostname,
              },
              "relationships" => {
                "geo_lookup" => {
                  "data" => {
                    "id" => geo_lookup2.id.to_s,
                    "type" => geo_lookup2.class.name.underscore
                  }
                }
              },
              "id" => geo_location2.id.to_s,
              "type" => geo_location2.class.name.underscore,
            },
          ]
        )
      end
    end # context "on success"
  end # describe "#index"

  describe "#show" do
    let!(:geo_location) { FactoryBot.create(:geo_location) }
    let(:geo_lookup) { geo_location.geo_lookup }
    let(:get_lookup_client_class) { class_double(GeoApi::Services::GetGeoLocation).as_stubbed_const }
    let(:get_lookup_client_instance) { instance_double(get_lookup_client_class, call: geo_location) }

    subject(:request) { get geo_locations_show_path(geo_location.geo_lookup.ip) }

    context "on success" do
      before do
        allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
        request
      end
      
      it "has status code 'success'" do
        expect(response).to have_http_status(:success)
      end

      it "responds with JSON" do
        expect(response.content_type).to eql("application/json; charset=utf-8")
      end

      it "responds with body" do
        expect(response.parsed_body).to match(
          "data" => {
            "attributes" => {
              "city" => geo_location.city,
              "continent_code" => geo_location.continent_code,
              "continent_name" => geo_location.continent_name,
              "country_name" => geo_location.country_name,
              "country_code" => geo_location.country_code,
              "id" => geo_location.id,
              "latitude" => geo_location.latitude.to_s,
              "longitude" => geo_location.longitude.to_s,
              "region_code" => geo_location.region_code,
              "region_name" => geo_location.region_name,
              "zip_code" => geo_location.zip_code,
              "ip" => geo_lookup.ip,
              "hostname" => geo_lookup.hostname,
            },
            "relationships" => {
              "geo_lookup" => {
                "data" => {
                  "id" => geo_lookup.id.to_s,
                  "type" => geo_lookup.class.name.underscore
                }
              }
            },
            "id" => geo_location.id.to_s,
            "type" => geo_location.class.name.underscore,
          },
        )
      end
    end # context "on success"

    context "on error" do
      let(:error_msg) { "boom!" }

      context "when geo location is NOT found" do
        before do
          allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
          allow(get_lookup_client_instance).to receive(:call).and_raise(ActiveRecord::RecordNotFound, error_msg)
          request
        end

        it "has status code 'error'" do
          expect(response).to have_http_status(:not_found)
        end

        it "responds with JSON" do
          expect(response.content_type).to eql("application/json; charset=utf-8")
        end

        it "responds with body" do
          expect(response.parsed_body).to match(
            "code" => ApplicationController::NOT_FOUND,
            "detail" => error_msg,
            "title" => ApplicationController::MSG_NOT_FOUND,
          )
        end
      end # context "when geo location is NOT found"

      context "when get geo location service raises an error" do
        before do
          allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
          allow(get_lookup_client_instance).to receive(:call).and_raise(StandardError, error_msg)
          request
        end

        it "has status code 'error'" do
          expect(response).to have_http_status(:error)
        end

        it "responds with JSON" do
          expect(response.content_type).to eql("application/json; charset=utf-8")
        end

        it "responds with body" do
          expect(response.parsed_body).to match(
            "code" => ApplicationController::INTERNAL_SERVER_ERROR,
            "detail" => error_msg,
            "title" => ApplicationController::MSG_INTERNAL_SERVER_ERROR,
          )
        end
      end # context "when get geo location service raises an error"
    end # context "on error"
  end # describe "#show"

  describe "#destroy" do
    let!(:geo_location) { FactoryBot.create(:geo_location) }
    let(:geo_lookup) { geo_location.geo_lookup }
    let(:get_lookup_client_class) { class_double(GeoApi::Services::GetGeoLocation).as_stubbed_const }
    let(:get_lookup_client_instance) { instance_double(get_lookup_client_class, call: geo_location) }

    subject(:request) { delete geo_locations_destroy_path(geo_location.geo_lookup.ip) }

    context "on success" do
      before do
        allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
      end

      it "has status code 'success'" do
        request
        expect(response).to have_http_status(:success)
      end

      it "destroys the geo lookup record" do
        expect { request }.to change { GeoLookup.count }.by(-1)
      end

      it "destroys the geo location record" do
        expect { request }.to change { GeoLocation.count }.by(-1)
      end

      it "responds with JSON" do
        request
        expect(response.content_type).to eql("application/json; charset=utf-8")
      end

      it "responds with body" do
        request
        expect(response.parsed_body).to match(
          "data" => {
            "attributes" => {
              "city" => geo_location.city,
              "continent_code" => geo_location.continent_code,
              "continent_name" => geo_location.continent_name,
              "country_name" => geo_location.country_name,
              "country_code" => geo_location.country_code,
              "id" => geo_location.id,
              "latitude" => geo_location.latitude.to_s,
              "longitude" => geo_location.longitude.to_s,
              "region_code" => geo_location.region_code,
              "region_name" => geo_location.region_name,
              "zip_code" => geo_location.zip_code,
              "ip" => geo_lookup.ip,
              "hostname" => geo_lookup.hostname,
            },
            "relationships" => {
              "geo_lookup" => {
                "data" => {
                  "id" => geo_lookup.id.to_s,
                  "type" => geo_lookup.class.name.underscore
                }
              }
            },
            "id" => geo_location.id.to_s,
            "type" => geo_location.class.name.underscore,
          },
        )
      end
    end # context "on success"

    context "on error" do
      let(:error_msg) { "boom!" }

      context "when geo location is NOT found" do
        before do
          allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
          allow(get_lookup_client_instance).to receive(:call).and_raise(ActiveRecord::RecordNotFound, error_msg)
        end

        it "does NOT destroy the geo lookup record" do
          expect { request }.to_not change { GeoLookup.count }
        end

        it "does NOT destroy the geo location record" do
          expect { request }.to_not change { GeoLocation.count }
        end

        it "has status code 'error'" do
          request
          expect(response).to have_http_status(:not_found)
        end

        it "responds with JSON" do
          request
          expect(response.content_type).to eql("application/json; charset=utf-8")
        end

        it "responds with body" do
          request
          expect(response.parsed_body).to match(
            "code" => ApplicationController::NOT_FOUND,
            "detail" => error_msg,
            "title" => ApplicationController::MSG_NOT_FOUND,
          )
        end
      end # context "when geo location is NOT found"

      context "when get lookup client service raises an error" do
        before do
          allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
          allow(get_lookup_client_instance).to receive(:call).and_raise(StandardError, error_msg)
        end

        it "does NOT destroy the geo lookup record" do
          expect { request }.to_not change { GeoLookup.count }
        end

        it "does NOT destroy the geo location record" do
          expect { request }.to_not change { GeoLocation.count }
        end

        it "has status code 'error'" do
          request
          expect(response).to have_http_status(:error)
        end

        it "responds with JSON" do
          request
          expect(response.content_type).to eql("application/json; charset=utf-8")
        end

        it "responds with body" do
          request
          expect(response.parsed_body).to match(
            "code" => ApplicationController::INTERNAL_SERVER_ERROR,
            "detail" => error_msg,
            "title" => ApplicationController::MSG_INTERNAL_SERVER_ERROR,
          )
        end
      end # context "when get lookup client service raises an error"
    end # context "on error"
  end # describe "#destroy"

  describe "create" do
    let(:geo_location) { FactoryBot.create(:geo_location) }
    let(:geo_lookup) { geo_location.geo_lookup }
    let(:geo_lookup_client) { double("client") }
    let(:get_lookup_client_class) { class_double(GeoApi::Services::GetLookupClient).as_stubbed_const }
    let(:get_lookup_client_instance) { instance_double(get_lookup_client_class, call: geo_lookup_client) }
    let(:set_geo_location_class) { class_double(GeoApi::Services::SetGeoLocation).as_stubbed_const }
    let(:set_geo_location_instance) { instance_double(set_geo_location_class, call: geo_location) }

    subject(:request) { post geo_locations_create_path(geo_location.geo_lookup.ip) }

    context "on success" do

      before do
        allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
        allow(set_geo_location_class).to receive(:new).and_return(set_geo_location_instance)
      end

      it "has status code 'success'" do
        request
        expect(response).to have_http_status(:success)
      end

      it "responds with JSON" do
        request
        expect(response.content_type).to eql("application/json; charset=utf-8")
      end

      it "responds with body" do
        request
        expect(response.parsed_body).to match(
          "data" => {
            "attributes" => {
              "city" => geo_location.city,
              "continent_code" => geo_location.continent_code,
              "continent_name" => geo_location.continent_name,
              "country_name" => geo_location.country_name,
              "country_code" => geo_location.country_code,
              "id" => geo_location.id,
              "latitude" => geo_location.latitude.to_s,
              "longitude" => geo_location.longitude.to_s,
              "region_code" => geo_location.region_code,
              "region_name" => geo_location.region_name,
              "zip_code" => geo_location.zip_code,
              "ip" => geo_lookup.ip,
              "hostname" => geo_lookup.hostname,
            },
            "relationships" => {
              "geo_lookup" => {
                "data" => {
                  "id" => geo_lookup.id.to_s,
                  "type" => geo_lookup.class.name.underscore
                }
              }
            },
            "id" => geo_location.id.to_s,
            "type" => geo_location.class.name.underscore,
          },
        )
      end
    end # context "on success"

    context "on error" do
      context "when get lookup client service raises an error" do
        let(:error_msg) { "boom!" }

        before do
          allow(get_lookup_client_class).to receive(:new).and_return(get_lookup_client_instance)
          allow(get_lookup_client_instance).to receive(:call).and_raise(StandardError, error_msg)
        end

        it "has status code 'error'" do
          request
          expect(response).to have_http_status(:error)
        end

        it "responds with JSON" do
          request
          expect(response.content_type).to eql("application/json; charset=utf-8")
        end

        it "responds with body" do
          request
          expect(response.parsed_body).to match(
            "code" => ApplicationController::INTERNAL_SERVER_ERROR,
            "detail" => error_msg,
            "title" => ApplicationController::MSG_INTERNAL_SERVER_ERROR,
          )
        end
      end # context "when get lookup client service raises an error"
    end # context "on error"
  end # describe "create"
end