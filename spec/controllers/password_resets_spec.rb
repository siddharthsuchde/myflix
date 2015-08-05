require 'spec_helper'

describe PasswordResetsController do
  describe 'GET#show' do
    it "renders show page when token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    
    it "redirects to an expired token page when token is invlaid" do
      alice = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
    
    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns[:token]).to eq('12345')
    end
  end
  
  describe "POST#create" do
    context "token is valid" do
      it "redirects to sign in page" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to login_path
      end
      
      it "changes the users password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end
      
      it "sets a flash message" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end
      
      it "regenerates the user token" do
        alice = Fabricate(:user)
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(alice.reload.token).not_to be('12345')
      end
      
    end
    context "token is invalid" do
      it "renders the invalid token page" do
        post :create, token: '12345', password: 'same_password'
        expect(response).to redirect_to expired_token_path
      end
    end
    
  end
  
  
  
  
end
