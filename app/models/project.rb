class Project < ApplicationRecord
  default_scope -> { order(:code) }
  validates :name, presence: true, length: {maximum: 30}, uniqueness: true
  validates :code, presence: true, length: {maximum: 30}, uniqueness: true

  def self.import(file)
    encoding = set_encoding(file)
    return "all_invalid" if encoding.nil?
    saved     = false
    all_saved = true
    CSV.foreach(file.path, encoding: encoding, headers: true, nil_value: "") do |row|
      if row["name"].present? && row["code"].present?
        project = new
        # CSVからデータを取得し、設定する
        project.name = row["name"]
        project.code = row["code"]
        # 保存する
        if project.save
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
