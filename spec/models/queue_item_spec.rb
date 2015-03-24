require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user)}
  it { should belong_to(:video)}
  
  
  describe "#video_title" do
    it "should set the video title" do
      video = Fabricate(:video, title: "Monk")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Monk")
    end
  end
  
  describe "#category_name" do
    it "returns the category name of the video" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Drama")
    end
    
  end
  
  describe "#category" do
    it "links to the relevant category page" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
  
  describe "#rating" do
    it "should show the rating of the relevant video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, rating: 2, video: video, user: user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(2)
    end
    
    it "should remain empty if no review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
    
    it "changes the rating if a review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    
    it "should remove a rating of an already present review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
    
    it "creates a rating if review not present" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 2
      expect(Review.first.rating).to eq(2)
    end
    
      
  end
    
  
  
end