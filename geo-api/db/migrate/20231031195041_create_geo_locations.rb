class CreateGeoLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geo_locations do |t|

      t.timestamps
    end
  end
end
