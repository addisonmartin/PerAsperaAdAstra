class Satellite < ApplicationRecord
  has_one :orbit, inverse_of: :satellite
end
