class IssueActivity < ApplicationRecord
  belongs_to :issue
  belongs_to :creator, class_name: "User"
end
