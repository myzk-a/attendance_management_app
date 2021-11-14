class Work < ApplicationRecord
  attr_accessor :start_hours
  attr_accessor :start_minutes
  attr_accessor :end_hours
  attr_accessor :end_minutes
  default_scope -> { order(:start_time) }
end
