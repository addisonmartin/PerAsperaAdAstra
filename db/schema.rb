# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_16_155858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "satellites", primary_key: "norad_catalog_id", force: :cascade do |t|
    t.text "international_designator", null: false
    t.text "name", null: false
    t.text "object_name", null: false
    t.text "object_type"
    t.text "object_id", null: false
    t.integer "object_number", null: false
    t.text "country", null: false
    t.date "launch_date"
    t.text "launch_site"
    t.date "decay_date"
    t.integer "launch_year", null: false
    t.integer "launch_number", null: false
    t.text "launch_piece", null: false
    t.decimal "period", precision: 12, scale: 2
    t.decimal "inclination", precision: 12, scale: 2
    t.bigint "apogee"
    t.bigint "perigee"
    t.integer "radar_cross_section_value", null: false
    t.text "radar_cross_section_size"
    t.text "comment"
    t.integer "comment_code"
    t.integer "file", null: false
    t.text "current", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
