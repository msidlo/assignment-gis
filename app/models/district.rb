class District < ApplicationRecord
  has_many :data, as: :imageable
end
