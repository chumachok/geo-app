require "resolv"
require "uri"

module GeoApi
  module Utils
    module Helper

      def self.valid_ip?(value:)
        !!(value =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex]))
      end

      def self.valid_url?(value:)
        uri = URI.parse(value)
        uri.kind_of?(URI::HTTP) && !uri.host.nil?
      rescue URI::Error
        false
      end

      def self.get_host(url:)
        URI.parse(url).host
      end

    end
  end
end