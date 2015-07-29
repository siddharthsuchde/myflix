require 'spec_helper'

feature 'user creates a follow list' do
  scenario 'user follows and removes leaders from his follow list' do
    sidd = Fabricate(:user, full_name: 'Sidd')
    smita = Fabricate(:user, full_name: 'Smita')
    category = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', category: category)
    review = Fabricate(:review, video: monk, user: smita)
    sign_in(sidd)
    visit home_path
    add_video_to_queue_on_home_page(monk)
    expect(page).to have_content monk.title
    
    click_link smita.full_name
    expect(page).to have_content smita.full_name
    
    click_link 'Follow'
    expect(page).to have_content smita.full_name
    
    unfollow(smita)
    expect(page).not_to have_content(smita.full_name)
   
  end
  
  private
  
  
  def unfollow(user)
    find("a[data-method= 'delete']").click
  end
  
  
end