json.extract! orbit, :id, :epoch, :first_derivative_of_mean_motion, :second_derivative_of_mean_motion, :b_star, :inclination, :right_ascension_of_ascending_node, :eccentricity, :argument_of_perigee, :mean_anomaly, :mean_motion, :revolution_number, :tles, :created_at, :updated_at
json.url orbit_url(orbit, format: :json)
