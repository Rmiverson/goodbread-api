class User < ApplicationRecord
    has_secure_password

    has_many :recipes, :dependent => :delete_all
    has_many :recipe_likes, :dependent => :delete_all
    has_many :boards, :dependent => :delete_all
    has_many :sub_boards, :dependent => :delete_all
 
    has_many :followed_users, foreign_key: :follower_id, class_name: "Relationship"
    has_many :followees, through: :followed_users, :dependent => :delete_all
 
    has_many :following_users, foreign_key: :followee_id, class_name: "Relationship"
    has_many :followers, through: :following_users, :dependent => :delete_all
 
end
