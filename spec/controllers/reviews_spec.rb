require 'spec_helper'

describe ReviewsController do
  describe "POST#create" do
    context "when there is a valid user" do
      let(:current_user){Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
      end
      
      context "when it is a valid review" do
        it "redirects to the video show page" do 
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video_path(video.id)
        end
        
        it "creates a review" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end
        
        it "creates a review with a signed in user" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(current_user)
        end
        
        
        it "creates a review associated with a video" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end
      end
      context "when it is an invalid review" do 
        it "renders the video show page" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(response).to render_template "videos/show"
        end
        
        it "does not create a new review" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(Review.count).to eq(0)
        end
        
        it "sets @video" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
        it "sets @review" do
          video = Fabricate(:video)
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
      
    end
      
    context "when there is an invalid user" do
      it "redirects to the login page" do
        session[:user_id] = nil
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
    
    
  end
end