# def rating is a pull method and def rating=(new rating) is a push method
# this is how you create virtual attributes in Active Record
# since queue items does not have a ratings attribute in it's table

class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_numericality_of :position, only_integer: :true
  
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
  
  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      #bypasses validations
      review.save(validate:false)
    end
  end
  
  
  
end
