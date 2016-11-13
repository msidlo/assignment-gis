class Datum < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  include Importable
end