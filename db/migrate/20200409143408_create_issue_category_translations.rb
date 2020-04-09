class CreateIssueCategoryTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_category_translations do |t|
      t.string :name
      t.string :language
      t.references :issue_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
