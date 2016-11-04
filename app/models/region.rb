class Region < ApplicationRecord
  has_many :data, as: :imageable
end
