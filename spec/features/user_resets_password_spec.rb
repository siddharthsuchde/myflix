require 'spec_helper'

feature 'user resets password' do
  scenario 'successfully changes password' do
    sidd = Fabricate(:user, password: 'old_password')
    visit forgot_password_path
    fill_in "Email Address", with: sidd.email
    click_button 'Send Email'
    open_email(sidd.email)
    current_email.click_link("Reset My Password")
    
    fill_in "Password", with: 'new_password'
    click_button 'Reset Password'
    
    fill_in "Email Address", with: sidd.email
    fill_in "Password", with: 'new_password'
    click_button 'Sign In'
    expect(page).to have_content sidd.full_name
    
    clear_email
  end
end