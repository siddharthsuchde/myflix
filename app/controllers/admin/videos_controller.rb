class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin
  
  def new
    @video = Video.new

  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to new_admin_video_path
      flash[:success] = "Your video #{@video.title} has been successfully uploaded"
    else
      flash[:error] = "Invalid credentials your video could not be uploaded"
      render :new
      
    end
  end
  
  private
  
  def require_admin
    if !current_user.admin?
      flash[:error] = "You Cannot Access This Page!"
      redirect_to home_path
    end
  end
  
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover, :video_url)
  end
  
end
