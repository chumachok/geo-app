class GeoLookup < ApplicationRecord
  LOOKUP_CLIENTS = [
    LOOKUP_CLIENT_IPSTACK = "ipstack",
  ].freeze

  validates :lookup_client, presence: true, inclusion: LOOKUP_CLIENTS
  validates :ip, presence: true, uniqueness: true
  validates :hostname, uniqueness: true, allow_blank: true

  has_one :geo_location, dependent: :destroy
end