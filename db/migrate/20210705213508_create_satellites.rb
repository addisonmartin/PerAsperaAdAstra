class CreateSatellites < ActiveRecord::Migration[6.1]
  def change
    create_table :satellites do |t|
      t.text :name
      t.integer :catalog_id
      t.text :international_designation
      t.date :launch_date
      t.date :decay_date
      t.text :country
      t.text :launch_site
      t.text :space_object_type
      t.text :radar_cross_section_size
      t.integer :element_number
      t.text :tles

      t.timestamps
    end
  end
end
