class User < ApplicationRecord
  before_save {email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.user.name_maximum}
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.user.email_maximum},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.password_minimum}

  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end
end
