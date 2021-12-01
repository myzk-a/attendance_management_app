class Project < ApplicationRecord
  has_many :works

  default_scope -> { order(:code) }
  validates :name, presence: true, length: {maximum: 30}, uniqueness: true
  validates :code, presence: true, length: {maximum: 30}, uniqueness: true

  private

    def self.update_attributes(row)
      row.to_hash.slice("name", "code")
    end

end
