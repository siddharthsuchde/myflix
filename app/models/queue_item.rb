class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  
  def video_title
    video.title
  end
  
  def category_name
    video.category.name
  end
  
  def category
    video.category
  end
  
  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
  
  
end
