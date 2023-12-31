class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! } # self.email = self.email.downcase
  validates :name, presence: true, 
                   length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  # возвращает дайджест для указанной строки
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
           BCrypt::Engine::MIN_COST :
           BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)       
  end

  paginates_per 10

  # возвращает случайный токен
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # запоминает пользователя в базе данных для использования в постоянных сеансах
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # возвращает true, если указанный дайджест соответствует токену
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)   
  end

  # забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end
end
