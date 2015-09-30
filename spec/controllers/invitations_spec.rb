require 'spec_helper'

describe InvitationsController do
  describe "GET#new" do
    it "sets @invitation to new invitation" do
      sidd = Fabricate(:user)
      set_current_user(sidd)
      get :new
      expect(assigns(:invitation)).to be_instance_of Invitation
      expect(assigns(:invitation)).to be_new_record
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :new}
    end
  end
  
  describe "POST#create" do
    context "valid inputs" do
      
      after {ActionMailer::Base.deliveries.clear}
      
      it_behaves_like "requires sign in" do
        let(:action) { post :create}
      end
      
      it "redirects to the new invitation page" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_name: "sidd", recipient_email: "sidd@lys.com", message: "Check out this cool site!"}
        expect(response).to redirect_to new_invitation_path
      end

      it "creates a new invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_name: "sidd", recipient_email: "sidd@lys.com", message: "Check out this cool site!"}
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_name: "sidd", recipient_email: "sidd@lys.com", message: "Check out this site!"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["sidd@lys.com"])
      end

      it "sets flash success message" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_name: "sidd", recipient_email: "sidd@lys.com", message: "check out this site"}
        expect(flash[:success]).to be_present
      end
    end
    
    context "invalid inputs" do
      
      
      it "renders the :new template" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_email: "sidd@lys.com"}
        expect(response).to render_template(:new)
      end
      
      it "does not send out an invitaiton email" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_email: "sidd@lys.com"}
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
      
      it "does not create and invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_email: "sidd@lys.com"}
        expect(Invitation.count).to eq(0)
      end
      
      it "sets flash error message" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_email: "sidd@lys.com"}
        expect(flash[:error]).to be_present
      end
      
      it "sets @invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: {recipient_email: "sidd@lys.com"}
        expect(assigns[:invitation]).to be_present
      end
      
    end
    
    
  end
  
end
