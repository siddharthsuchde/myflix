require 'spec_helper'

describe QueueItemsController do
  describe "GET#index" do
    it "sets the @queue_item to the current user" do
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      queue_item1 = Fabricate(:queue_item, user: sidd)
      queue_item2 = Fabricate(:queue_item, user: sidd)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it "redirects to the login page for unauthroized user" do
      sidd = Fabricate(:user)
      session[:user_id] = nil
      queue_item1 = Fabricate(:queue_item, user: sidd)
      queue_item2 = Fabricate(:queue_item, user: sidd)
      get :index
      expect(response).to redirect_to login_path
      
    end
  end
  
  describe "POST#create" do
    it "should redirect to the my queue page" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
      
    it "should create a queue item" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates a queue item associated with a video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.first.video).to eq(video)
      
    end
    it "creates a queue item associated with a user" do
      video = Fabricate(:video)
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.first.user).to eq(sidd)
    end
      
    it "puts the video as the last one in the queue" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      Fabricate(:queue_item, video: video, user: sidd)
      monk = Fabricate(:video)
      post :create, video_id: monk.id
      queue_item2 = QueueItem.where(video_id: monk.id, user_id: sidd.id).first
      expect(queue_item2.position).to eq(2)
    end
    
    it "does not add video to queue if video already exists" do
      monk= Fabricate(:video)
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      Fabricate(:queue_item, video: monk, user: sidd)
      post :create, video_id: monk.id
      expect(sidd.queue_items.count).to eq(1)
      
    end
    
    
    
    it "redirects to sign in page for unauthorized users" do
      video = Fabricate(:video)
      session[:user_id] = nil
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(response).to redirect_to login_path
    end
  end
  
  describe "DELETE#destroy" do
    it "should delete a queue item from the list" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      q1 = Fabricate(:queue_item, video: video, user: sidd)
      delete :destroy, id: q1.id
      expect(QueueItem.count).to eq(0)
    end
    it "should redirect back to my_queue page" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      session[:user_id] = sidd.id
      q1 = Fabricate(:queue_item, video: video, user: sidd)
      delete :destroy, id: q1.id
      expect(response).to redirect_to my_queue_path
    end
  end
  
  
  
  
  
end