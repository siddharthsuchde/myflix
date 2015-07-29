require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order("position")}
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:email)}
  
  it "generates a random token for each newly created user" do
    sidd = Fabricate(:user)
    expect(sidd.token).to be_present
  end
  
  
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
  
  describe "#follows?(another_user)" do
    it "returns true if the current user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).should be_true
    end
    
    it "returns false if the current user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      sam = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: sam)
      expect(alice.follows?(bob)).should be_false
    end
  end
  
  
end