class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search)
      where('title LIKE ?', "%#{search}%")
  end
  
  
  
end
