require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST#create" do
  
    context "user does not enter an email address" do
      it "redirects to forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "gives an error message saying email field is blank" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cant be blank")
      end
    end

    context "user enters a valid email address" do
      it "sends out a forgot password email to the email address" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
      
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end
    
    context "user enters an invalid email address" do
      it "redirects to the forgot password page" do
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_path
      end
      
      it "gives an error message saying the email is invalid" do
        post :create, email: "joe@example.com"
        expect(flash[:error]).to eq("The email entered is invalid")
      end
      
    end
    
  end
end
