class QueueItemsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @queue_items = QueueItem.all
  end
  
  def create
    @video = Video.find(params[:video_id])
    QueueItem.create(video: @video, user: current_user, position: current_user.queue_items.count + 1) unless current_user.queue_items.map(&:video).include?(@video)
    redirect_to my_queue_path
    
  end
  
  def destroy
    @queue_item = QueueItem.find(params[:id])
    if @queue_item.destroy
      redirect_to my_queue_path
    end
    
    
  end
  
end
