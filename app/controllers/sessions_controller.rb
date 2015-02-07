class SessionsController < ApplicationController
  # sessions controller is used for authentication
  def new
    redirect_to home_path if current_user
  end
  
  def create
    user = User.find_by(email: params[:email])
    #if user exists and password entered is correct
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "Congratulations! You Have Successfully Signed In"
    else
      flash[:error] = "Invalid Username or Password"
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are now logged out"
  end
  
  
end
