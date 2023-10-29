# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
# user = User.create(
#   name: "Admin User",
#   email: "email@example.org",
#   password: "password",
#   password_confirmation: "password",
#   terms_of_service: true
# )
# Jumpstart.grant_system_admin!(user)

LanguageTag.find_or_create_by(name: "English")
LanguageTag.find_or_create_by(name: "Spanish")
LanguageTag.find_or_create_by(name: "French")
LanguageTag.find_or_create_by(name: "German")
LanguageTag.find_or_create_by(name: "Italian")
LanguageTag.find_or_create_by(name: "Portuguese")
LanguageTag.find_or_create_by(name: "Russian")
LanguageTag.find_or_create_by(name: "Japanese")
LanguageTag.find_or_create_by(name: "Chinese")
LanguageTag.find_or_create_by(name: "Korean")
LanguageTag.find_or_create_by(name: "Arabic")
LanguageTag.find_or_create_by(name: "Hindi")
LanguageTag.find_or_create_by(name: "Turkish")
LanguageTag.find_or_create_by(name: "Dutch")
LanguageTag.find_or_create_by(name: "Polish")
LanguageTag.find_or_create_by(name: "Swedish")
LanguageTag.find_or_create_by(name: "Norwegian")
LanguageTag.find_or_create_by(name: "Danish")
LanguageTag.find_or_create_by(name: "Finnish")
LanguageTag.find_or_create_by(name: "Czech")
LanguageTag.find_or_create_by(name: "Hungarian")
LanguageTag.find_or_create_by(name: "Romanian")
LanguageTag.find_or_create_by(name: "Greek")
LanguageTag.find_or_create_by(name: "Thai")
LanguageTag.find_or_create_by(name: "Indonesian")
LanguageTag.find_or_create_by(name: "Vietnamese")
LanguageTag.find_or_create_by(name: "Hebrew")
LanguageTag.find_or_create_by(name: "Persian")
LanguageTag.find_or_create_by(name: "Malay")
LanguageTag.find_or_create_by(name: "Bulgarian")
LanguageTag.find_or_create_by(name: "Slovak")
LanguageTag.find_or_create_by(name: "Ukrainian")
LanguageTag.find_or_create_by(name: "Croatian")

ActivityTag.find_or_create_by(name: "Adventure")
ActivityTag.find_or_create_by(name: "Architecture")
ActivityTag.find_or_create_by(name: "Art & Culture")
ActivityTag.find_or_create_by(name: "City")
ActivityTag.find_or_create_by(name: "Countryside & Nature")
ActivityTag.find_or_create_by(name: "Day Trip")
ActivityTag.find_or_create_by(name: "Family")
ActivityTag.find_or_create_by(name: "Food & Drink")
ActivityTag.find_or_create_by(name: "History")
ActivityTag.find_or_create_by(name: "Honeymoon")
ActivityTag.find_or_create_by(name: "Nightlife")
ActivityTag.find_or_create_by(name: "Relaxation")
ActivityTag.find_or_create_by(name: "Shopping")
ActivityTag.find_or_create_by(name: "Sightseeing")
ActivityTag.find_or_create_by(name: "Sports")
ActivityTag.find_or_create_by(name: "Walking")
ActivityTag.find_or_create_by(name: "Water Sports")
ActivityTag.find_or_create_by(name: "Winter Sports")
ActivityTag.find_or_create_by(name: "Workshops & Classes")
ActivityTag.find_or_create_by(name: "Yoga & Meditation")
ActivityTag.find_or_create_by(name: "Zoo & Aquarium")
