# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

load(Rails.root.join("db", "seeds.rb"))

comedies = Category.create(name: 'Comedies')
drama = Category.create(name: 'Drama')
romance = Category.create(name: 'Romance')

Video.create(title: "family_guy", description: "This is a great video", small_cover: File.open(File.join(Rails.root, '/tmp/family_guy.jpg')), large_cover: File.open(File.join(Rails.root, '/tmp/family_guy.jpg')), video_url: 'https://diikjwpmj92eg.cloudfront.net/uploads/week6/HW3%20watch%20video.mp4' category: comedies)
Video.create(title: "futurama", description: "This is average", small_cover_url: "futurama", category: comedies )
Video.create(title: "monk", description: "not highly rate", small_cover_url: "monk", category: drama)
Video.create(title: "south_park", description: "Adult comdey", small_cover_url: "south_park", category: romance)

