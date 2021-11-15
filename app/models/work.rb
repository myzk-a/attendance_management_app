class Work < ApplicationRecord
  attr_accessor :start_hours
  attr_accessor :start_minutes
  attr_accessor :end_hours
  attr_accessor :end_minutes
  default_scope -> { order(:start_time) }

  validates :user_id,      presence: true
  validates :user_name,    presence: true
  validates :project_id,   presence: true
  validates :content,      presence: true, length: {maximum: 30}
end
