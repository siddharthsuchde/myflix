require 'spec_helper'

feature 'User invites friend' do
  scenario 'successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)
    user_sends_invitation
    
    friend_signs_up
    
    friend_signs_in
    
    friend_follows_user(alice)
    inviter_follows_friend(alice)
    
    clear_email
    
  end
  
  private
  
  def user_sends_invitation
    visit new_invitation_path
    fill_in "Friends Name", with: "John Doe"
    fill_in "Friends Email Address", with: "john@example.com"
    fill_in "Invitation Message", with: "Please join this site"
    click_button 'Send Invitation'
    sign_out
  end
  
  def friend_signs_up
    open_email "john@example.com"
    current_email.click_link("Accept this Invitation")
    fill_in "Password", with: 'password'
    fill_in "Full Name", with: 'John Doe'
    click_button 'Sign Up'
  end
  
  def friend_signs_in
    fill_in "Email Address", with: 'john@example.com'
    fill_in "Password", with: 'password'
    click_button 'Sign In'
  end
  
  def friend_follows_user(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end
  
  def inviter_follows_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "John Doe"
  end
  
  
  
  
end
