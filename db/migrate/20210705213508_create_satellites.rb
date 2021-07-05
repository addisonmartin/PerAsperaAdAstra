class CreateSatellites < ActiveRecord::Migration[6.1]
  def change
    create_table :satellites do |t|
      t.text :name
      t.integer :catalog_number
      t.text :international_designation
      t.datetime :launch_date
      t.datetime :decay_date
      t.integer :element_number
      t.text :tles
      t.has_one :orbit

      t.timestamps
    end
  end
end
