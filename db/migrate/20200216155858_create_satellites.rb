class CreateSatellites < ActiveRecord::Migration[6.0]
  def change
    create_table :satellites, id: false do |t|
      t.primary_key :norad_catalog_id

      t.text :international_designator, null: false, limit: 12
      t.text :name, null: false, limit: 25
      t.text :object_name, null: false, limit: 25
      t.text :object_type, null: true, limit: 12
      t.text :object_id, null: false, limit: 12
      t.integer :object_number, null: false, unsigned: true, precision: 8
      t.text :country, null: false
      t.date :launch_date, null: true
      t.text :launch_site, null: true
      t.date :decay_date, null: true
      t.integer :launch_year, null: false, unsigned: true, precision: 5
      t.integer :launch_number, null: false, unsigned: true, precision: 5
      t.text :launch_piece, null: false, limit: 3
      t.decimal :period, null: true, precision: 12, scale: 2
      t.decimal :inclination, null: true, precision: 12, scale: 2
      t.bigint :apogee, null: true, precision: 12
      t.bigint :perigee, null: true, precision: 12
      t.integer :radar_cross_section_value, null: false, precision: 1
      t.text :radar_cross_section_size, null: true
      t.text :comment, null: true, limit: 32
      t.integer :comment_code, null: true, unsigned: true, precision: 3
      t.integer :file, null: false, unsigned: true, precision: 5
      t.text :current, null: false, limit: 1

      t.timestamps
    end
  end
end
