require "resolv"

module GeoApi
  module Utils
    module Helper
      def valid_ip?(value:)
        !!(value =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex])
      end
    end
  end
end