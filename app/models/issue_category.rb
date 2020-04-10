class IssueCategory < ApplicationRecord
  has_many :issues
  has_many :issue_sub_categories
  has_many :issue_category_translations



  def self.suspected_patient
    IssueCategory.where(name: "Report a patient (shared with officers only)")
  end

  # def name
  #   if REDIS.get("LOCALE").present?
  #     translation = IssueCategoryTranslation.where(issue_category_id: id, language: REDIS.get("LOCALE"))&.first&.name
  #     translation.present? ? translation : read_attribute(:name)
  #   else
  #     read_attribute(:name)
  #   end
  # end
end
