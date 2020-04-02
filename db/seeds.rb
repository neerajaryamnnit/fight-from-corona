# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

issue_subs = [{name: "Need Medical Help", category: "Medical"}, {name: "Need Grocery Help", category: "Grocery"}, {name: "Need Baby Milk", category: "Grocery"}]

issue_subs.each do |cat|
  category = IssueCategory.where(name: cat[:category]).first_or_create!
  IssueSubCategory.where(name: cat[:name], issue_category_id: category.id).first_or_create!
end