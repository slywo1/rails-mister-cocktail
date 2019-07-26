# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

if Rails.env.development?
  Cocktail.destroy_all
  Dose.destroy_all
  Ingredient.destroy_all
end

url = "https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json"
opened_url = open(url).read
parsed_url = JSON.parse(opened_url)

parsed_url.each do |cocktail|
  c = Cocktail.create!(name: cocktail["name"])
  cocktail["ingredients"].each do |ingredient|
    if ingredient["ingredient"]
      i = Ingredient.find_or_create_by(name: ingredient["label"].present? ? ingredient["label"] : ingredient["ingredient"])
      d = Dose.create!(description: ingredient["amount"].to_s + " " + ingredient["unit"], cocktail: c, ingredient: i)
    end
  end
end
