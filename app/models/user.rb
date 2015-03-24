class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> {order("position")}
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :password, presence: true
  validates :email, presence: true
  validates_uniqueness_of :email
  
  def queue_video?(video)
    queue_items.map(&:video).include?(video)
  end
  
end
