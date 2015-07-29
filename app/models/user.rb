class User < ActiveRecord::Base
  has_many :reviews
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_many :queue_items, -> { order("position") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leading_relationship, class_name: "Relationship", foreign_key: "leader_id"
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :password, presence: true
  validates :email, presence: true
  validates_uniqueness_of :email
  before_create :generate_token
  
  def queue_video?(video)
    queue_items.map(&:video).include?(video)
  end
  
  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
end

  
  
  
  