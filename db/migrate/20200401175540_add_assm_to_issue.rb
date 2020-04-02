class AddAssmToIssue < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :aasm_state, :string
  end
end
