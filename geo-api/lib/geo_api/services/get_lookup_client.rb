module GeoApi
  module Services
    class GetLookupClient < Base
      ERROR_MESSAGE_UNSUPPORTED_LOOKUP_CLIENT = "unsupported lookup client '%s'"

      def call
        lookup_client = Rails.application.credentials[:lookup_client]
        case lookup_client
        when GeoLocation::LOOKUP_CLIENT_IPSTACK
          access_key = Rails.application.credentials[:ipstack_access_key]
          client = GeoApi::Clients::Ipstack.new(
            access_key: access_key
          )
        else
          raise StandardError, ERROR_MESSAGE_UNSUPPORTED_LOOKUP_CLIENT % lookup_client
        end
      end
    end
  end
end