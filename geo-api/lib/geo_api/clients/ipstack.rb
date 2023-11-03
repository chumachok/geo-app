module GeoApi
  module Clients

    # https://ipstack.com/documentation
    class Ipstack
      BASE_URL = "http://api.ipstack.com/"
      DEFAULT_TIMEOUT = { connect: 5, write: 5, read: 10 }.freeze

      attr_reader :connection, :type

      def initialize(access_key:, base_url: BASE_URL, timeout: DEFAULT_TIMEOUT)
        @connection = GeoApi::Utils::HttpWrapper.new(BASE_URL,
          headers: default_headers,
          timeout: timeout,
        )
        @access_key = access_key
        @type = GeoLookup::LOOKUP_CLIENT_IPSTACK
      end

      def ip_lookup(ip:)
        res = connection.get("/#{ip}?access_key=#{@access_key}")
        handle_response(res: res, caller_m: __method__.to_s)
      end

      def hostname_lookup(hostname:)
        res = connection.get("/#{hostname}?access_key=#{@access_key}&hostname=1")
        handle_response(res: res, caller_m: __method__.to_s)
      end

      private

      def handle_response(res:, caller_m:)
        if res&.status&.success?
          body = JSON.parse(res.body, symbolize_names: true)
          if body["success"] == false
            raise StandardError, "#{caller_m} request failed, type: #{body["type"]}, info: #{body["info"]}"
          end

          body
        else
          raise StandardError, "#{caller_m} request failed with '#{res&.status}' status"
        end
      end

      def default_headers
        {
          "Content-Type" => "application/json",
        }
      end
    end

  end
end
