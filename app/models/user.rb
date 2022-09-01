class User < ApplicationRecord
    has_secure_password

    has_many :folders, :dependent => :destroy
    has_many :recipes, :dependent => :destroy
    has_many :sub_folders, through: :folders, :dependent => :destroy
end
