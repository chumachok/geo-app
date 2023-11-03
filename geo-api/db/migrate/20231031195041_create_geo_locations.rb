class CreateGeoLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_locations do |t|
      t.string :continent_code
      t.string :continent_name
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zip_code
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.references :geo_lookup, foreign_key: true
      t.timestamps
    end

  end
end