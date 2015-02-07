require 'spec_helper'

describe UsersController do
  describe 'GET#new' do
    it "should set @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe 'POST#create' do
    context 'when user credentials are valid' do
      it 'should create a new user' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end
      it 'should redirect to login_path' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end
    
    context 'when user credentials are invalid' do
      it 'should not create a user' do
        post :create, user: { email: "sidd@lys.com", full_name: "sidd"}
        expect(User.count).to eq(0)
      end
       
      it 'should render a new template' do
        post :create, user: { email: "sidd@lys.com", full_name: "sidd"}
        expect(response).to render_template :new
      end
      
    end
  end
  
  
end
