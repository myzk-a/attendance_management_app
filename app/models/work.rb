class Work < ApplicationRecord
  attr_accessor :start_hours
  attr_accessor :start_minutes
  attr_accessor :end_hours
  attr_accessor :end_minutes
  default_scope -> { order(:start_time) }

  validates :user_id,      presence: true
  validates :user_name,    presence: true
  validates :start_time,   presence: true, work_period: true
  validates :end_time,     presence: true, work_period: true
  validate  :time_integrity
  #valiidate :minutes_integrity
  validates :project_id,   presence: true
  validates :content,      presence: true, length: {maximum: 30}

  #バリデーションメソッド
  def time_integrity
    return if start_time.blank? || end_time.blank?
    errors.add(:start_time, "と終了時刻の整合性がとれません") if start_time >= end_time
  end

  def minutes_integrity
    return if start_time.blank? || end_time.blank?
    errors.add(:start_time, "は15分刻みで入力してください") if start_time.min % 15 != 0
    errors.add(:end_time,   "は15分刻みで入力してください") if end_time.min % 15 != 0
  end

end
