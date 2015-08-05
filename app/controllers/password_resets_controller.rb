class PasswordResetsController < ApplicationController
  
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end
  
  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      redirect_to login_path
      flash[:success] = "Your Passwords Has Been Successfully Updated"
    else
      redirect_to expired_token_path
    end
  end
  
  def expired_token
  end
  
end
