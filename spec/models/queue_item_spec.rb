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
      
  end
    
  
  
end