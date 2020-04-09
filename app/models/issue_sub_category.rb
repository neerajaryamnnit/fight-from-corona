class IssueSubCategory < ApplicationRecord
  belongs_to :issue_category
  has_many :issue_sub_category_translations
end
