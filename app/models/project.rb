class Project < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}, uniqueness: true
  validates :code, presence: true, length: {maximum: 30}, uniqueness: true
end
