class GeoLocationsController < ApplicationController

  def index
    geo_locations = GeoLocation.last(10)
    render success(GeoLocationSerializer.new(geo_locations).serializable_hash)
  end

  def show
    geo_location = GeoApi::Services::GetGeoLocation.new.call(lookup_value: params[:lookup_value])
    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end

  def create
    lookup_value = params[:lookup_value]
    lookup_client = GeoApi::Services::GetLookupClient.new.call
    geo_location_data = GeoApi::Services::GetRemoteGeoLocation.new.call(
      client: lookup_client,
      lookup_value: lookup_value,
    )

    geo_lookup = GeoLookup.find_by(ip: geo_location_data[:ip])
    if geo_lookup
      geo_lookup.update!(
        lookup_client: lookup_client.type,
        ip: geo_location_data[:ip],
        hostname: geo_location_data[:hostname],
      )
      geo_lookup.geo_location.update!(
        continent_code: geo_location_data[:continent_code],
        continent_name: geo_location_data[:continent_name],
        country_code: geo_location_data[:country_code],
        country_name: geo_location_data[:country_name],
        region_code: geo_location_data[:region_code],
        region_name: geo_location_data[:region_name],
        city: geo_location_data[:city],
        zip_code: geo_location_data[:zip],
        latitude: geo_location_data[:latitude],
        longitude: geo_location_data[:longitude],
      )
    else
      geo_lookup = GeoLookup.create!(
        lookup_client: lookup_client.type,
        ip: geo_location_data[:ip],
        hostname: geo_location_data[:hostname],
      )
      geo_location = GeoLocation.create!(
        continent_code: geo_location_data[:continent_code],
        continent_name: geo_location_data[:continent_name],
        country_code: geo_location_data[:country_code],
        country_name: geo_location_data[:country_name],
        region_code: geo_location_data[:region_code],
        region_name: geo_location_data[:region_name],
        city: geo_location_data[:city],
        zip_code: geo_location_data[:zip],
        latitude: geo_location_data[:latitude],
        longitude: geo_location_data[:longitude],
      )
    end

    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end

  def destroy
    geo_location = GeoApi::Services::GetGeoLocation.new.call(lookup_value: params[:lookup_value])
    geo_location.geo_lookup.destroy!

    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end
end