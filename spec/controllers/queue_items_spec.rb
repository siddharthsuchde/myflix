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
end