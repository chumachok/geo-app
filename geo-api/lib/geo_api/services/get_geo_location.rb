module GeoApi
  module Services
    class GetGeoLocation < Base
      ERROR_MSG_INVALID_LOOKUP_VALUE = "invalid lookup value '%s'"

      def call(lookup_value:)
        if UtilsHelper.valid_ip?(value: lookup_value)
          geo_lookup = GeoLookup.find_by!(ip: lookup_value)
        elsif UtilsHelper.valid_url?(value: lookup_value)
          geo_lookup = GeoLookup.find_by!(hostname: lookup_value)
        else
          raise StandardError, ERROR_MSG_INVALID_LOOKUP_VALUE % lookup_value
        end

        geo_lookup.geo_location
      end

    end
  end
end