class Orbit < ApplicationRecord
  belongs_to :satellite, inverse_of: :orbit, optional: true

  validates :name, presence: true
  validates :inclination, :apogee, :perigee, :first_derivative_of_mean_motion, :second_derivative_of_mean_motion, :b_star, :right_ascension_of_ascending_node, :eccentricity, :argument_of_perigee, :mean_anomaly, :mean_motion, numericality: { allow_nil: true }
  validates :revolution_number, numericality: { only_integer: true, allow_nil: true }

  # validates :tles, length: { maximum: 162 }
  # validates :tles, format: { with: /^[A-Z0-9\+\- ]*$/, message: 'can only contain capital letters, numbers, spaces, and pluses and minus signs' }

  # scope :low_earth, -> { where(perigee < 200 and apogee < 200) }
  # scope :medium_earth, -> { where(perigee < 200 and apogee < 200) }
  # scope :geostationary, -> { where(perigee < 200 and apogee < 200) }
  # scope :heliocentric, -> { where(perigee < 200 and apogee < 200) }
end
