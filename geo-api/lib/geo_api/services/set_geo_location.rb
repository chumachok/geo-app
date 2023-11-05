module GeoApi
  module Services
    class SetGeoLocation < Base
      def call(lookup_client:, lookup_value:)
        geo_location_data = GeoApi::Services::GetRemoteGeoLocation.new.call(
          client: lookup_client,
          lookup_value: lookup_value,
        )
        geo_location = nil
        geo_lookup = GeoLookup.find_by(ip: geo_location_data[:ip])
        ActiveRecord::Base.transaction do
          # remove hostname from any previous records, as we should rely on the last value
          if UtilsHelper.valid_url?(value: lookup_value)
            GeoLookup.where(hostname: geo_location_data[:hostname]).update_all(hostname: nil)
          end
          if geo_lookup
            geo_lookup.update!(
              lookup_client: lookup_client.type,
              ip: geo_location_data[:ip],
              hostname: geo_location_data[:hostname],
            )
            geo_location = geo_lookup.geo_location
            geo_location.update!(
              continent_code: geo_location_data[:continent_code],
              continent_name: geo_location_data[:continent_name],
              country_code: geo_location_data[:country_code],
              country_name: geo_location_data[:country_name],
              region_code: geo_location_data[:region_code],
              region_name: geo_location_data[:region_name],
              city: geo_location_data[:city],
              zip_code: geo_location_data[:zip],
              latitude: geo_location_data[:latitude],
              longitude: geo_location_data[:longitude],
            )
          else
            geo_lookup = GeoLookup.create!(
              lookup_client: lookup_client.type,
              ip: geo_location_data[:ip],
              hostname: geo_location_data[:hostname],
            )
            geo_location = GeoLocation.create!(
              continent_code: geo_location_data[:continent_code],
              continent_name: geo_location_data[:continent_name],
              country_code: geo_location_data[:country_code],
              country_name: geo_location_data[:country_name],
              region_code: geo_location_data[:region_code],
              region_name: geo_location_data[:region_name],
              city: geo_location_data[:city],
              zip_code: geo_location_data[:zip],
              latitude: geo_location_data[:latitude],
              longitude: geo_location_data[:longitude],
              geo_lookup: geo_lookup,
            )
          end
        end

        geo_location
      end

    end
  end
end