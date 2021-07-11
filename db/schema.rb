# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_05_213508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orbits", force: :cascade do |t|
    t.text "name", null: false
    t.text "epoch"
    t.decimal "first_derivative_of_mean_motion"
    t.decimal "second_derivative_of_mean_motion"
    t.decimal "b_star"
    t.decimal "inclination"
    t.decimal "apogee"
    t.decimal "perigee"
    t.decimal "period"
    t.decimal "right_ascension_of_ascending_node"
    t.decimal "eccentricity"
    t.decimal "argument_of_perigee"
    t.decimal "mean_anomaly"
    t.decimal "mean_motion"
    t.integer "revolution_number"
    t.text "tles"
    t.bigint "satellite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["satellite_id"], name: "index_orbits_on_satellite_id"
  end

  create_table "satellites", force: :cascade do |t|
    t.text "name", null: false
    t.integer "catalog_id", null: false
    t.text "international_designation", null: false
    t.date "launch_date", null: false
    t.date "decay_date"
    t.text "country"
    t.text "launch_site"
    t.text "space_object_type", null: false
    t.text "radar_cross_section_size"
    t.integer "element_number"
    t.text "tles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
