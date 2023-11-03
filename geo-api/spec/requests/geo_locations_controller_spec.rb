require "rails_helper"

RSpec.describe GeoLocationsController, type: :request do
  let(:headers) do
    {
      "Accept" => "application/json",
    }
  end

  describe "#index" do
    let!(:geo_location1) { FactoryBot.create(:geo_location) }
    let!(:geo_location2) { FactoryBot.create(:geo_location) }
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
              },
              "id" => geo_location2.id.to_s,
              "type" => geo_location2.class.name.underscore,
            },
          ]
        )
      end
    end # context "on success"
  end # describe "#index"

  # describe "#show" do

  # end # describe "#show"

  # describe "#destroy" do
  #   context "on success" do
  #     context "when ip v4 is provided" do
  #       it "destroys geo location record" do

  #       end
  #     end

  #     context "when ip v6 is provided" do
  #       it "destroys geo location record" do

  #       end
  #     end

  #     context "when url is provided" do
  #       it "destroys geo location record" do

  #       end
  #     end
  #   end # context "on success"
  # end # describe "#destroy"

  # describe "create" do

  # end # describe "create"
end