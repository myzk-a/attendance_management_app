class Work < ApplicationRecord
  belongs_to :user
  belongs_to :project
  default_scope -> { order(:start_time) }

  before_save :set_project_name_and_project_code
  before_save :set_user_name

  validates :user_id,    presence: true
  validates :start_time, presence: true, work_period: true
  validates :end_time,   presence: true, work_period: true
  validates :content,    presence: true, length: {maximum: 30}
  validate  :time_integrity
  validate  :minutes_integrity
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


  #before_saveアクション
  def set_project_name_and_project_code
    self.project_name = project.name
    self.project_code = project.code
  end

  def set_user_name
    self.user_name = user.name
    self.user_name_no_blank = user.name.gsub(/(\s|　)+/, '')
  end

  scope :search, -> (search_params) do
    period_is(search_params[:year], search_params[:month])
      .user_name_is(search_params[:user_name], search_params[:user_name_pull_down])
      .project_name_is(search_params[:project_name], search_params[:project_name_pull_down])
  end

  scope :period_is, -> (year, month) do
    if year.present? && month.present?
      str_date = year + "-" + month + "-01"
      date = str_date.to_date
      range = date.beginning_of_month..date.end_of_month
      where(start_time: range)
    end
  end

  scope :user_name_is, -> (user_name, user_name_pull_down) do
    if user_name_pull_down.present?
      where(user_name: user_name_pull_down)
    else
      if user_name.present?
        user_name.gsub!(/(\s|　)+/, '')
        where('user_name_no_blank LIKE ?', "%#{user_name}")
      end
    end
  end

  scope :project_name_is, -> (project_name, project_name_pull_down) do
    if project_name_pull_down.present?
      where(project_name: project_name_pull_down)
    else
      where('project_name LIKE ?', "%#{project_name}") if project_name.present?
    end
  end

end
