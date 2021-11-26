class User < ApplicationRecord
  attr_accessor :remember_token
  attr_accessor :password_reset

  default_scope -> { order(:email) }

  before_save {self.email = email.downcase}
  
  validates :name,  presence: true, length: {maximum: 20}
  
  VALID_EMAIL_REGEX = /#{ENV.fetch("VALID_EMAIL_REGEX"){""}}/
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

  private

    def self.update_attributes(row)
      input_params = row.to_hash.slice("name", "email")
      input_params["password"]              = ENV.fetch("USER_DEFAULT_PASSWORD"){""}
      input_params["password_confirmation"] = ENV.fetch("USER_DEFAULT_PASSWORD"){""}
      return input_params
    end

end
