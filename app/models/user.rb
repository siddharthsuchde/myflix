class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :password, presence: true
  validates :email, presence: true
  validates_uniqueness_of :email
  
end
