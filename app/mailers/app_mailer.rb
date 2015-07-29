class AppMailer < ActionMailer::Base
  
  def send_welcome_email(user)
    @user = user
    mail from: "info@myflix.com", to: @user.email, subject: "Thanks for Signing Up!"
  end
  
  def forgot_password_email(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Please Reset Password"
  end
  
end
