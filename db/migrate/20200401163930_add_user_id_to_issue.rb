class AddUserIdToIssue < ActiveRecord::Migration[6.0]
  def change
    add_reference :issues, :user, foreign_key: true
    add_column :issues, :address, :string
    add_column :issues, :reported_at, :datetime
    add_column :issues, :resolved_at, :datetime
    add_reference :issues, :resolved_by, foreign_key: { to_table: :users }
  end
end
