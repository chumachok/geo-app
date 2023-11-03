require "faker"

FactoryBot.define do
  factory :geo_lookup do
    ip { Faker::Internet.ip_v6_address }
    hostname { GeoApi::Utils::Helper.get_host(url: Faker::Internet.url) }
    lookup_client { GeoLookup::LOOKUP_CLIENT_IPSTACK }
  end

  factory :geo_location do
    continent_code { "NA" }
    continent_name { "North America" }
    country_code { Faker::Address.country_code }
    country_name { Faker::Address.country }
    region_code { Faker::Address.state_abbr }
    region_name { Faker::Address.state }
    city { Faker::Address.city }
    zip_code { Faker::Address.zip }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    association :geo_lookup
  end
end