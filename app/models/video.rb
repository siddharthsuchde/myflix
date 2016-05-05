class Video < ActiveRecord::Base
  belongs_to :category
  has_many :user_videos
  has_many :users, through: :user_videos
  has_many :reviews, -> { order "created_at DESC"}
  has_many :queue_items
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search)
    return [] if search.blank?
    where('title LIKE ?', "%#{search}%").order("created_at DESC")
  end
  
  
  
end
