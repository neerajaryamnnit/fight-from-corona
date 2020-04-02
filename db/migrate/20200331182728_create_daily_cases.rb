class CreateDailyCases < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_cases do |t|
      t.integer :total
      t.integer :decease
      t.integer :recover
      t.integer :active
      t.integer :suspected
      t.datetime :last_updated_at
      t.timestamps
    end
  end
end
