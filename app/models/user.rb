class User < ApplicationRecord
  before_validation { email.downcase! }
  has_secure_password
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments
  mount_uploader :profile_photo, ImageUploader
end
