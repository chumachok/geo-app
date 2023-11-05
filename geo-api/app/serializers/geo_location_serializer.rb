class GeoLocationSerializer < ApplicationSerializer
  attributes :id, :continent_code, :continent_name, :country_name, :country_code, :region_code, :region_name
  attributes :city, :zip_code, :latitude, :longitude

  belongs_to :geo_lookup

  attribute :ip do |object|
    object.geo_lookup.ip
  end

  attribute :hostname do |object|
    object.geo_lookup.hostname
  end
end