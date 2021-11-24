class Holiday < ApplicationRecord
  default_scope -> { order(:date) }
  validates :name, presence: true, length: {maximum: 20}
  validates :date, presence: true, uniqueness: true

  scope :search, -> (search_params) do
    str_date = search_params[:year] + "-01-01"
    date = str_date.to_date
    range = date.beginning_of_year..date.end_of_year
    where(date: range)
  end

  def self.import(file)
    encoding = set_encoding(file)
    return "all_invalid" if encoding.nil?
    saved     = false
    all_saved = true
    CSV.foreach(file.path, encoding: encoding, headers: true, nil_value: "") do |row|
      #pattern : yyyy/mm/dd
      pattern = /\d{4}\/\d{1,2}\/\d{1,2}/
      if row["name"].present? && row["date"].present? && row["date"].match(pattern)
        holiday = new
        # CSVからデータを取得し、設定する
        holiday.name = row["name"]
        holiday.date = row["date"].to_date unless row["date"].blank?
        # 保存する
        if holiday.save && saved == false
          saved = true
        else
          all_saved = false
        end
      end
    end
    if all_saved && saved
      return "all_saved"
    elsif saved
      return "some_are_invalid"
    else
      return "all_invalid"
    end
  end

end
