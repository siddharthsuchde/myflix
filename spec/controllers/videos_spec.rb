require 'spec_helper'

describe VideosController do
  describe "GET#show" do
    it "sets the @video variable when the user is signed in" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video)
      get :show, id: video1.id
      assigns(:video).should == video1
    end
    
    it "sets the @reviews variable when the user is signed in" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video)
      review1 = Fabricate(:review, video: video1)
      review2 = Fabricate(:review, video: video1)
      get :show, id: video1.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    
    it "redirects to login page for unauthorized users" do
      video1 = Fabricate(:video)
      get :show, id: video1.id
      expect(response).to redirect_to login_path
    end
  end
  
  describe "POST#search" do
    it "sets @results for all authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "futurama")
      post :search, search: "rama"
      expect(assigns(:results)).to eq([futurama])
    end
    
    it "redirects to sign in page for unauthenticated users" do
      futurama = Fabricate(:video, title: "futurama")
      post :search, search: "rama"
      expect(response).to redirect_to login_path
      
    end
  end
end
