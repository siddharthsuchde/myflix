require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end
    
    it "sets the @video to a new video" do
      alice = Fabricate(:admin)
      set_current_admin(alice)
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end
    
    it "redirects regular user to the home path" do
      alice = Fabricate(:user)
      set_current_user(alice)
      get :new
      expect(response).to redirect_to home_path
    end
    
    it "sets flash error for regular user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      get :new
      expect(flash[:error]).to be_present
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end
    
    it_behaves_like "requires admin" do
      let(:action) {post :create}
    end
    
    context "with valid inputs" do
      it "redirects to new videos upload page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Inception", description: "futuristic movie", category_id: category.id}
        expect(response).to redirect_to new_admin_video_path
      end
      
      it "creates a new video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Inception", description: "futuristic movie", category_id: category.id}
        expect(category.videos.count).to eq(1)
      end
      
      it "sets flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Inception", description: "futuristic movie", category_id: category.id}
        expect(flash[:success]).to be_present
      end
    end
    
    context "with invalid inputs" do
      it "renders a new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: "futuristic movie", category_id: category.id}
        expect(response).to render_template :new
      end
      
      it "sets the @video variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: "futuristic movie", category_id: category.id}
      end
      
      it "sets flash error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: "futuristic movie", category_id: category.id}
        expect(flash[:error]).to be_present
      end
    end
  end
  
end
