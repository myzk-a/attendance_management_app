# 抽選期間に重複がないかを検証するバリデーター
class WorkPeriodValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 新規登録する期間
    new_start_time = record.start_time
    new_end_time   = record.end_time

    return unless new_start_time.present? && new_end_time.present?

     # 重複する期間を検索(編集時は自期間を除いて検索)
    if record.id.present?
      not_own_periods = Work.where('id NOT IN (?) AND start_time <= ? AND end_time >= ?', record.id, new_end_time, new_start_time)
    else
      not_own_periods = Work.where('start_time <= ? AND end_time >= ?', new_end_time, new_start_time)
    end

    record.errors.add(attribute, 'に重複があります') if not_own_periods.present?
  end
end