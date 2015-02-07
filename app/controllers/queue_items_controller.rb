class QueueItemsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @queue_items = QueueItem.all
  end
  
end
