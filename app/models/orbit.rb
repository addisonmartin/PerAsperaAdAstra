class Orbit < ApplicationRecord
  belongs_to :satellite, inverse_of: :orbit, optional: true

  # validates :tles, length: { maximum: 162 }
  # validates :tles, format: { with: /^[A-Z0-9\+\- ]*$/, message: 'can only contain capital letters, numbers, spaces, and pluses and minus signs' }
end
