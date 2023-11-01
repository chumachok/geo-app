class GeoLocationsController < ApplicationController

  def index
    geo_locations = GeoLocation.last(10)
    render success(GeoLocationSerializer.new(geo_locations).serializable_hash)
  end

  def show

  end

  def create
    lookup_value = params[:lookup_value]
    lookup_client = GeoApi::Services::GetLookupClient.new.call
    if GeoApi::Utils::Helper.valid_ip?(lookup_value: lookup_value)
      geo_location_data = GeoApi::Services::GetRemoteGeoLocation.new.call(
        client: lookup_client,
        lookup_value: lookup_value,
        lookup_type: GeoLocation::LOOKUP_TYPE_IP,
      )
    else
      geo_location_data = GeoApi::Services::GetRemoteGeoLocation.new.call(
        client: lookup_client,
        lookup_value: lookup_value,
        lookup_type: GeoLocation::LOOKUP_TYPE_HOSTNAME,
      )
    end

    geo_location = GeoLocation.create!

    render success(GeoLocationSerializer.new(geo_location).serializable_hash)
  end

  def destroy
    if GeoApi::Utils::Helper.valid_ip?(lookup_value: params[:lookup_value])
      GeoLocation.find_by!(ip: params[:lookup_value]).destroy!
    else
      GeoLocation.find_by!(hostname: params[:lookup_value]).destroy!
    end
  end
end