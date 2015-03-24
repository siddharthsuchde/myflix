require 'spec_helper'

feature 'user interacts with the queue' do
  scenario 'user adds and reorders video to the queue' do
    category = Fabricate(:category)
    monk = Fabricate(:video, category: category, title: "Monk")
    futurama = Fabricate(:video, category: category, title: "Futurama")
    south_park = Fabricate(:video, category: category, title: "South Park")
    sidd = Fabricate(:user)
    sign_in(sidd)
    visit home_path
    add_video_to_queue(monk)
    expect(page).to have_content monk.title
    
    click_link '+ My Queue'
    expect(page).to have_content monk.title
    
    click_link monk.title
    visit video_path(monk)
    page.should_not have_content('+ My Queue')
    
    visit home_path
    # add 2 more Videos to My Queue
    add_video_to_queue(futurama)
    click_link '+ My Queue'
    visit home_path
    add_video_to_queue(south_park)
    click_link '+ My Queue' 
    #expect(page).to have_content south_park.title
    #expect(page).to have_content futurama.title
    # first find the element via inspect element
    # then set it e.g. with:1
    # then run test to see if it's set
    set_video_position(monk, 3)
    set_video_position(futurama, 1)
    set_video_position(south_park, 2)
    
    
    expect_video_position(monk, 3)
    expect_video_position(futurama, 1)
    expect_video_position(south_park, 2)
  end
  
  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(., '#{video.title}')] //input[@type = 'text']").value).to eq(position.to_s)
  end
  
  def set_video_position(video, position)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end
  
  def add_video_to_queue(video)
    find("a[href= '/videos/#{video.id}']").click
  end
  
  
end







