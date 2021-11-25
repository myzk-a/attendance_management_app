class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private
    def self.set_encoding(file)
      require 'nkf'
      # 文字コード検証部分
      file.tempfile.gets #ヘッダー部分をとばす
      headers_str = file.tempfile.gets # 2行目の最初のレコードを取得
      return nil if headers_str.nil?
      encoding = NKF.guess(headers_str) # NKFモジュールで文字コードの判定
      encoding = "BOM|#{encoding}" if encoding == Encoding::UTF_8 # UTF-8なら、BOM| をつける。
      return encoding
    end

    def self.header_is_valid?(row, attributes)
      valid = true
      attributes.each do |attribute|
        valid = false if row[attribute].blank?
      end
      return valid
    end

    def self.import(file, attributes)
      encoding = set_encoding(file)
      return "all_invalid" if encoding.nil?
      saved     = false
      all_saved = true
      CSV.foreach(file.path, encoding: encoding, headers: true, nil_value: "") do |row|
        if header_is_valid?(row, attributes)
          instance = new
          # CSVからデータを取得し、設定する
          instance.attributes = update_attributes(row)

          # 保存する
          if instance.save
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
