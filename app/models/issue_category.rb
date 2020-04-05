class IssueCategory < ApplicationRecord
  has_many :issues
  has_many :issue_sub_categories



  def self.suspected_patient
    IssueCategory.where(name: "Report a patient (shared with officers only)")
  end
end
