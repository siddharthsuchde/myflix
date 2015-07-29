class ForgotPasswordsController < ApplicationController
  
  def new
    
  end
  
  def create
    user = User.where(email:params[:email]).first
    if user
      AppMailer.forgot_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cant be blank" : "The email entered is invalid"
      redirect_to forgot_password_path
    end
  end
  
  def confirmation
  end
  
end