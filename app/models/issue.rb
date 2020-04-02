class Issue < ApplicationRecord
  include AASM
  belongs_to :issue_category
  belongs_to :issue_sub_category
  aasm do
    state :open, initial: true
    state :resolved
    event :mark_resolve do
      transitions from: :open, to: :resolved
    end
  end
end
