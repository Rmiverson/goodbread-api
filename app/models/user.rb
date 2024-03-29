class User < ApplicationRecord
  has_secure_password

  has_many :folders, :dependent => :destroy
  has_many :recipes, :dependent => :destroy
  has_many :tags, :dependent => :destroy

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
    length: { minimum: 8 },
    if: -> { new_record? || !password.nil?}
end
