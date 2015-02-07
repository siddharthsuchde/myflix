class ReviewsController < ApplicationController
  # user .merge for multiple associations
  before_filter :require_user
  
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params.merge!(user: current_user))
    if @review.save
      flash[:notice] = "Your review was succcessfully published"
      redirect_to video_path(@video)
    else
      # this is just for TDD test purpose 
      @reviews = @video.reviews.reload
      flash[:notice] = "The review cannot be created"
      render "videos/show"
      
    end
    
  end
  
  
  private
  
  def review_params
    params.require(:review).permit(:rating, :content)
  end
  
  
  
end
