class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :description
      t.float :lat
      t.float :long
      t.references :issue_category, foreign_key: true
      t.references :issue_sub_category, foreign_key: true

      t.timestamps
    end
  end
end
