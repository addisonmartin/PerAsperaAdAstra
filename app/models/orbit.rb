class Orbit < ApplicationRecord
  belongs_to :satellite, inverse_of: :orbit
end
