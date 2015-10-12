require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order("position")}
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:email)}
  
  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user)}
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
  
  describe "#follow(another_user)" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_true
    end
    
    it "does not follow self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_false
    end
  end
  
end