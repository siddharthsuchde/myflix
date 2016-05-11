def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path  
  fill_in :email, :with => user.email
  fill_in :password, :with => user.password
  click_button 'Sign In'
end

def sign_out
  visit logout_path
end


def set_current_user(user=nil)
  session[:user_id] = ( user || Fabricate(:user.id)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = ( admin || Fabricate(:admin)).id
end

def add_video_to_queue_on_home_page(video)
  find("a[href= '/videos/#{video.id}']").click
end
