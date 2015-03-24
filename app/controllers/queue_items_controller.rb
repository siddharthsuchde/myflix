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
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    normalize_queue_items
    redirect_to my_queue_path
  end
  
  
  def update_queue
    begin
      update_queue_items
      #normalizes position number in my_queue
      normalize_queue_items
      # raise an exception via active record if a record is invalid
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position number"
    end
    redirect_to my_queue_path  
  end  
  
  private
  
  def update_queue_items
    #if 1 queue item fails a validation rollback all q_items even the ones which were saved
    # so if q_it1 is valid input and saves but q_it2 is invalid and doesnt rollback q_it1 to initial position value
    # transaction ensures the values are NOT saved
    ActiveRecord::Base.transaction do
      # changes position to valid input in my_queue
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if queue_item.user == current_user
      end
    end
    
    def normalize_queue_items
      #normalizes position number in my_queue
      current_user.queue_items.each_with_index do |queue_item, index|
        queue_item.update_attributes(position: index + 1) 
      end
    end
  end
  
  
  
end
