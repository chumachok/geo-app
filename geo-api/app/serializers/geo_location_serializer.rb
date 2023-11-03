class GeoLocationSerializer < ApplicationSerializer
  attributes :id, :continent_code, :continent_name, :country_name, :country_code, :region_code, :region_name
  attributes :city, :zip_code, :latitude, :longitude
end