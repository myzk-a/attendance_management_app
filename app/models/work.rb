class Work < ApplicationRecord
  default_scope -> { order(:start_time) }
end
