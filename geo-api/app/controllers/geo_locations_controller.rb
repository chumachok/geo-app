class GeoLocationsController < ApplicationController

  def index
    geo_locations = GeoLocation.includes(:geo_lookup).last(10)
    render success(GeoLocationSerializer.new(geo_locations).serializable_hash)
  end

  def show
    geo_location = GeoApi::Services::GetGeoLocation.new.call(lookup_value: params[:lookup_value])
    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end

  def create
    lookup_value = params[:lookup_value]
    lookup_client = GeoApi::Services::GetLookupClient.new.call
    geo_location = GeoApi::Services::SetGeoLocation.new.call(
      lookup_client: lookup_client,
      lookup_value: params[:lookup_value]
    )

    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end

  def destroy
    geo_location = GeoApi::Services::GetGeoLocation.new.call(lookup_value: params[:lookup_value])
    geo_location.geo_lookup.destroy!

    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end
end