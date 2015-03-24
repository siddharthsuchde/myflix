require 'spec_helper'

describe QueueItemsController do
  describe "GET#index" do
    it "sets the @queue_item to the current user" do
      sidd = Fabricate(:user)
      set_current_user(sidd)
      queue_item1 = Fabricate(:queue_item, user: sidd)
      queue_item2 = Fabricate(:queue_item, user: sidd)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end
  
  describe "POST#create" do
    it "should redirect to the my queue page" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      set_current_user(user)
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
      
    it "should create a queue item" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      set_current_user(user)
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates a queue item associated with a video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      set_current_user(user)
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.first.video).to eq(video)
      
    end
    it "creates a queue item associated with a user" do
      video = Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      post :create, queue_item: Fabricate.attributes_for(:queue_item), video_id: video.id
      expect(QueueItem.first.user).to eq(sidd)
    end
      
    it "puts the video as the last one in the queue" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      Fabricate(:queue_item, video: video, user: sidd)
      monk = Fabricate(:video)
      post :create, video_id: monk.id
      queue_item2 = QueueItem.where(video_id: monk.id, user_id: sidd.id).first
      expect(queue_item2.position).to eq(2)
    end
    
    it "does not add video to queue if video already exists" do
      monk= Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      Fabricate(:queue_item, video: monk, user: sidd)
      post :create, video_id: monk.id
      expect(sidd.queue_items.count).to eq(1)
      
    end
    
    
    
    it_behaves_like "requires sign in" do
      let(:action) {post :create, queue_item: Fabricate.attributes_for(:queue_item) }
    end
  end
  
  describe "DELETE#destroy" do
    it "should delete a queue item from the list" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      q1 = Fabricate(:queue_item, video: video, user: sidd)
      delete :destroy, id: q1.id
      expect(QueueItem.count).to eq(0)
    end
    it "should redirect back to my_queue page" do
      video= Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      q1 = Fabricate(:queue_item, video: video, user: sidd)
      delete :destroy, id: q1.id
      expect(response).to redirect_to my_queue_path
    end
    
    it "should normalize the queue items" do
      video= Fabricate(:video)
      video2= Fabricate(:video)
      sidd = Fabricate(:user)
      set_current_user(sidd)
      q1 = Fabricate(:queue_item, video: video, user: sidd, position: 1)
      q2 = Fabricate(:queue_item, video: video2, user: sidd, position: 2)
      delete :destroy, id: q1.id
      expect(QueueItem.first.position).to eq(1)
    end
    
  end
  
  describe "POST#update_queue" do
    context "with valid inputs" do
      # use let since the queue_item is the spec that is posted to server
      # therefore needs to be defined upfront
      let(:video1) {Fabricate(:video)}
      let(:video2) {Fabricate(:video)}
      let(:sidd) {Fabricate(:user)}
      let(:queue_item1) {Fabricate(:queue_item, user: sidd, position: 1, video: video1)}
      let(:queue_item2) {Fabricate(:queue_item, user: sidd, position: 2, video: video2)}
      
      before do
        set_current_user(sidd) 
      end
      
      it "should redirect to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "should reorder the queue" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(sidd.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it"should normalize the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 4}, {id: queue_item2.id, position: 3}]
        expect(sidd.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    
    
    context "with invalid inputs" do
      let(:video1) {Fabricate(:video)}
      let(:video2) {Fabricate(:video)}
      let(:sidd) {Fabricate(:user)}
      let(:queue_item1) {Fabricate(:queue_item, user: sidd, position: 1, video: video1)}
      let(:queue_item2) {Fabricate(:queue_item, user: sidd, position: 2, video: video2)}
      
      before do
        set_current_user(sidd) 
      end

      it "should redirect to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 3}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "should flash an error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 3}]
        expect(flash[:error]).to be_present
      end
      
      it "should no change the queue items position" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.4}]
        expect(queue_item1.reload.position).to eq(1)
      end
        
    end
    
    
    context "with unauthorized user" do
      it "should redirect to login path" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, position: 1, video: video1)
        queue_item2 = Fabricate(:queue_item, position: 2, video: video2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to login_path
      end
    end
    
    context "with queue items that don't belong to current user" do
      it "should not change the queue items" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        sidd = Fabricate(:user)
        set_current_user(sidd)
        sam = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: sam, position: 1, video: video1)
        queue_item2 = Fabricate(:queue_item, user: sidd, position: 2, video: video2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    
    
  end
  
  
  
end