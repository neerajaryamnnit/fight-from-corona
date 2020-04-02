class IssueCategory < ApplicationRecord
  has_many :issues
  has_many :issue_sub_categories
end
