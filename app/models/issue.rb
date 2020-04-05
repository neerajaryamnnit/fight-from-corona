class Issue < ApplicationRecord
  include AASM
  belongs_to :issue_category
  belongs_to :issue_sub_category, optional: true
  belongs_to :user
  belongs_to :resolved_by, class_name: "User", optional: true
  aasm do
    state :open, initial: true
    state :helping
    state :resolved
    event :mark_resolve do
      transitions from: :open, to: :resolved
    end
    event :mark_helping do
      transitions from: :open, to: :helping
    end
  end
end
