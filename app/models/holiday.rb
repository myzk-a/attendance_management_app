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
    CSV.foreach(file.path, encoding: "BOM|UTF-8", headers: true, nil_value: "") do |row|
      if row["name"].present? && row["date"].present?
        # 同じdateのレコードが見つかれば呼び出し、見つかれなければ、新しく作成
        holiday = new
        # CSVからデータを取得し、設定する
        holiday.name = row["name"]
        holiday.date = row["date"].to_date unless row["date"].blank?
        # 保存する
        holiday.save
      end
    end
  end
end
