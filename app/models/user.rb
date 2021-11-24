class User < ApplicationRecord
  attr_accessor :remember_token
  attr_accessor :password_reset

  default_scope -> { order(:email) }

  before_save {self.email = email.downcase}
  
  validates :name,  presence: true, length: {maximum: 20}
  
  VALID_EMAIL_REGEX = /\A[a-z\d]+_+[a-z]+@as-mobi\.com+\z/
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.import(file)
    encoding = set_encoding(file)
    return "all_invalid" if encoding.nil?
    saved     = false
    all_saved = true
    CSV.foreach(file.path, encoding: encoding, headers: true, nil_value: "") do |row|
      if row["name"].present? && row["email"].present?
        user = new
        # CSVからデータを取得し、設定する
        user.name = row["name"]
        user.email = row["email"]
        user.password = "password"
        user.password_confirmation = "password"

        # 保存する
        if user.save
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
