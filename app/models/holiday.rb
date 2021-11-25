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

  private

    def self.update_attributes(row)
      input_params = row.to_hash.slice("name", "date")
      #pattern : yyyy/mm/dd
      pattern = /\d{4}\/\d{1,2}\/\d{1,2}/
      row["date"].match(pattern) ? input_params["date"] = row["date"].to_date : input_params["date"] = ""
      return input_params
    end

end
