class SessionsController < ApplicationController
  # sessions controller is used for authentication
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:email])
    #if user exists and password entered is correct
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
  
end
