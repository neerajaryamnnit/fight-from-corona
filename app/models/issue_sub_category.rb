class IssueSubCategory < ApplicationRecord
  belongs_to :issue_category
  has_many :issue_sub_category_translations

  def name
    if REDIS.get("LOCALE").present?
      translation = IssueSubCategoryTranslation.where(issue_sub_category_id: id, language: REDIS.get("LOCALE"))&.first&.name
      translation.present? ? translation : read_attribute(:name)
    else
      read_attribute(:name)
    end
  end
end
