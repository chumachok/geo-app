class CreateGeoLookups < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_lookups do |t|
      t.string :ip
      t.string :hostname
      t.string :lookup_client

      t.timestamps
    end
  end
end