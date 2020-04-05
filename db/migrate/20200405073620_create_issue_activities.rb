class CreateIssueActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_activities do |t|
      t.string :name
      t.references :creator, null: true, foreign_key: {to_table: "users"}
      t.references :issue, null: true, foreign_key: true

      t.timestamps
    end
  end
end
