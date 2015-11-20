class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }

  # Name Validations
  validates :name, presence: true, length: { maximum: 50 }

  # Email Validations
  VALID_EMAIL_REGEX = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # Password Validations
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
end
