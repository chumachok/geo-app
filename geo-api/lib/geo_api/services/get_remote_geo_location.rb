module GeoApi
  module Services
    class GetRemoteGeoLocation < Base
      ERROR_MESSAGE_UNSUPPORTED_LOOKUP_TYPE = "unsupported lookup type %s"

      def call(client:, lookup_value:, lookup_type:)
        case lookup_type
        when GeoLocation::LOOKUP_TYPE_IP
          res = client.ip_lookup(ip: lookup_value)
        when GeoLocation::LOOKUP_TYPE_HOSTNAME
          res = client.hostname_lookup(ip: lookup_value)
        else
          raise StandardError, ERROR_MESSAGE_UNSUPPORTED_LOOKUP_TYPE % lookup_type
        end

        res
      end
    end
  end
end