class Holiday < ApplicationRecord
  default_scope -> { order(:date) }
  validates :name, presence: true, length: {maximum: 20}
  validates :date, presence: true, uniqueness: true
end
