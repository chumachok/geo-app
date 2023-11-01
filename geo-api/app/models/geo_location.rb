class GeoLocation < ApplicationRecord
  LOOKUP_TYPES = [
    LOOKUP_TYPE_IP = "ip",
    LOOKUP_TYPE_HOSTNAME = "hostname"
  ].freeze

  LOOKUP_CLIENTS = [
    LOOKUP_CLIENT_IPSTACK = "ipstack",
  ].freeze
end