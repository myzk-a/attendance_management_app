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

end
