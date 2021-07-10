class CreateSatellites < ActiveRecord::Migration[6.1]
  def change
    create_table :satellites do |t|
      t.text :name, null: false
      t.integer :catalog_id, null: false, unique: true
      t.text :international_designation, null: false, unique: true
      t.date :launch_date, null: false
      t.date :decay_date
      t.text :country
      t.text :launch_site
      t.text :space_object_type, null: false
      t.text :radar_cross_section_size
      t.integer :element_number
      t.text :tles

      t.timestamps
    end
  end
end
