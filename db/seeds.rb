# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'
csv_text = File.read('db/catego.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  category = IssueCategory.where(name: row[0]).first_or_create!
  IssueCategoryTranslation.where(name: row[0], issue_category_id: category.id, language: "en").first_or_create!
  IssueCategoryTranslation.where(name: row[1], issue_category_id: category.id, language: "hn").first_or_create!
  issue_sub = IssueSubCategory.where(name: row[1], issue_category_id: category.id).first_or_create!
  IssueSubCategoryTranslation.where(name: row[2], issue_sub_category_id: issue_sub.id, language: "en").first_or_create!
  IssueSubCategoryTranslation.where(name: row[3], issue_sub_category_id: issue_sub.id, language: "hn").first_or_create!
end

env_value = { LOCALE: "en"  }
env_value.keys.each do |key|
  AppConfig.where(key: key, value: env_value[key]).first_or_create!
end

