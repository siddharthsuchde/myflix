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
      
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'john@example.com')
        post :create, user: { email: "john@example.com", password: "password", full_name: "John Doe"}, invitation_token: invitation.token
        john = User.where(email: 'john@example.com').first
        expect(john.follows?(alice)).to be_true
      end
      
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'john@example.com')
        post :create, user: {email: "john@example.com", password: "password", full_name: "John Doe"}, invitation_token: invitation.token
        john = User.where(email: 'john@example.com').first
        expect(alice.follows?(john)).to be_true
      end
      
      it "expires the invitation token upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'john@example.com')
        post :create, user: {email: "john@example.com", password: "password", full_name: "John Doe"}, invitation_token: invitation.token
        john = User.where(email: 'john@example.com').first
        expect(Invitation.first.token).to be_nil
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
    
    context 'sending emails' do
      after {ActionMailer::Base.deliveries.clear}
      
      it 'does not send out email with invalid inputs' do
        post :create, user: {email: 'sidd@lys.com'}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it 'sends email to the right recipient with valid inputs' do
        post :create, user: { email: 'sidd@lys.com', password: 'password', full_name: "sidd"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['sidd@lys.com'])
      end
      
      it 'sends out email containing users name with valid inputs' do
        post :create, user: {email: 'sidd@lys.com', password: 'password', full_name: "sidd"}
        expect(ActionMailer::Base.deliveries.last.body).to include('sidd')
      end
    end
  end
  
  describe 'GET#new_with_invitation_token' do
    it "renders the new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    
    it "fills the email field with the recipients email address" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns[:user].email).to eq(invitation.recipient_email)
    end
    
    it "redirects to expired token page for expired token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: 'abcdefg'
      expect(response).to redirect_to expired_token_path
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns[:invitation_token]).to eq(invitation.token)
    end
    
    
  end
  
  
end
