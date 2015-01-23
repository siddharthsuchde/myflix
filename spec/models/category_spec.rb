require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  
  describe "recent_videos" do
    it "should return videos in reverse chronological order" do
      dramas = Category.create(name: "Dramas")
      futurama = Video.create(title: "Futurama", description: "a movie on the future", category: dramas, created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "another movie on the future", category: dramas)
      monk = Video.create(title: "Monk", description: "an interesting movie", category: dramas, created_at: 1.week.ago)
      expect(dramas.recent_videos).to eq([back_to_future, futurama, monk])
    end
    
    it "should return only the 6 most recent videos if there are more than 6 videos" do
      dramas = Category.create(name: "Dramas")
      futurama = Video.create(title: "Futurama", description: "a movie on the future", category: dramas, created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "another movie on the future", category: dramas)
      monk = Video.create(title: "Monk", description: "an interesting movie", category: dramas, created_at: 1.week.ago)
      south_park = Video.create(title: "South Park", description: "this movie has offensive language", category: dramas, created_at: 2.days.ago)
      gladiator = Video.create(title: "Gladiator", description: "a movie about the Roman empire", category: dramas, created_at: 5.days.ago)
      imitation_game = Video.create(title: "Imitation Game", description: "this movie is simply great", category: dramas, created_at: 4.days.ago)
      avatar = Video.create(title: "Avatar", description: "this movie has great special effects", category: dramas, created_at: 3.days.ago)
      expect(dramas.recent_videos).to eq([back_to_future, futurama, south_park, avatar, imitation_game, gladiator])
      
    end
    
  end
end
