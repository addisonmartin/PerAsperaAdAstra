class Satellite < ApplicationRecord
  has_one :orbit, inverse_of: :satellite

  # validates :tles, length: { maximum: 162 }
  # validates :tles, format: { with: /^[A-Z0-9\+\- ]*$/, message: 'can only contain capital letters, numbers, spaces, and pluses and minus signs' }

  # scope :rocket_bodies, -> { where(space_object_type: 'ROCKET BODY') }
  # scope :payloads, -> { where(space_object_type: 'PAYLOAD') }
  # scope :debris, -> { where(space_object_type: 'DEBRIS')
  # scope :unknown, -> { where(space_object_type: 'TBA') }

  # scope :in_orbit, -> { where(decay_date: nil) }
  # scope :decayed, -> { where.not(decay_date: nil) }

  # scope :starlink, -> { where('name ILIKE ?', 'STARLINK%') }
end
