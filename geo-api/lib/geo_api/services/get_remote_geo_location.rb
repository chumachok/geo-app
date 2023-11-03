module GeoApi
  module Services
    class GetRemoteGeoLocation < Base
      ERROR_MESSAGE_INVALID_LOOKUP_VALUE = "invalid lookup value '%s'"

      def call(client:, lookup_value:)
        if UtilsHelper.valid_ip?(value: lookup_value)
          res = client.ip_lookup(ip: lookup_value)
        elsif UtilsHelper.valid_url?(value: lookup_value)
          hostname = UtilsHelper.get_host(url: lookup_value)
          res = client.hostname_lookup(hostname: hostname)
        else
          raise StandardError, ERROR_MESSAGE_INVALID_LOOKUP_VALUE % lookup_value
        end

        res
      end
    end
  end
end