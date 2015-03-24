require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order("position")}
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:email)}
  
  
  describe "#queue_video?(video)" do
    it "return true if the selected video is already in the queue item" do
      user = Fabricate(:user)
      monk = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: monk)
      user.queue_video?(monk).should be_true
    end
    
    it "returns false if the selected video is not in the queue item" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user)
      user.queue_video?(video).should be_false
    end
    
    
  end
  
  
end