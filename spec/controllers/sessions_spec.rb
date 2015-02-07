require 'spec_helper'

describe SessionsController do
  
  describe "GET#new" do
    it "redirects to the home page for authorized users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
    
    it "renders a new template for unauthorized users" do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe "POST#create" do
    context "when a user logs in with valid credentials" do
      it "puts the signed in user in the session" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(session[:user_id]).to eq(alice.id)
      end
      it "redirects to the home page" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(response).to redirect_to home_path
      end
      it "sets the notice" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
        expect(flash[:notice]).not_to be_blank
      end
    end
    
    context "when a user logs in with invalid credentials" do
      it "sets does not put the signed in user in the session" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'adjjf'
        expect(session[:user_id]).to be_blank
  
      end
      it "redirects to sign in page" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aldkfj'
        expect(response).to redirect_to login_path
      end
      it "sets the notice" do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aldjf'
        expect(flash[:error]).not_to be_blank
      end
    end  
  end
  
  describe "GET#destroy" do
    it "clears the session for the user" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be_nil
    end
    
    it "redirects to the root path" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to root_path
    end
    
    it "sets the notice" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(flash[:notice]).not_to be_blank
    end
  end
  
end


