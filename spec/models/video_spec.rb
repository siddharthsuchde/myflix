require 'spec_helper'

describe Video do
      
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  
end

describe "search_by_title" do
  it "returns an empty array when there is no match" do
    futurama = Video.create(title: "Futurama", description: "A movie about the future!")
    back_to_the_future = Video.create(title: "Back to the Future", description: "another movie about the future.")
    expect(Video.search_by_title("hello")).to eq([])
  end
  
  it "returns an array of one when there is an exact match" do
    futurama = Video.create(title: "Futurama", description: "A movie about the future!")
    back_to_the_future = Video.create(title: "Back to the Future", description: "another movie about the future.")
    expect(Video.search_by_title("Futurama")).to eq([futurama])
  end
  
  it "returns an ordered array when there is a partial match"
  
  it "returns an empty array for a search with an empty string" 
  
end

