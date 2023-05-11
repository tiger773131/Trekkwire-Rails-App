class CreateOperatingLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :operating_locations do |t|
      t.integer :position
      t.string :address
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
