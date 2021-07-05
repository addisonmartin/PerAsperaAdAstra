class CreateOrbits < ActiveRecord::Migration[6.1]
  def change
    create_table :orbits do |t|
      t.text :epoch
      t.decimal :first_derivative_of_mean_motion
      t.decimal :second_derivative_of_mean_motion
      t.decimal :b_star
      t.decimal :inclination
      t.decimal :apogee
      t.decimal :perigee
      t.decimal :period
      t.decimal :right_ascension_of_ascending_node
      t.decimal :eccentricity
      t.decimal :argument_of_perigee
      t.decimal :mean_anomaly
      t.decimal :mean_motion
      t.integer :revolution_number
      t.text :tles

      t.belongs_to :satellite

      t.timestamps
    end
  end
end
