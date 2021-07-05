json.extract! satellite, :id, :name, :catalog_number, :international_designation, :launch_date, :decay_date, :element_number, :tles, :orbit, :created_at, :updated_at
json.url satellite_url(satellite, format: :json)
