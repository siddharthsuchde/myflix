# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "family_guy", description: "This is a great video", small_cover_url: "family_guy")
Video.create(title: "futurama", description: "This is average", small_cover_url: "futurama" )
Video.create(title: "monk", description: "not highly rate", small_cover_url: "monk" )

