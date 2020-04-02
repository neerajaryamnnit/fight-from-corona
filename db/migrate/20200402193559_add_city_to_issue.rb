class AddCityToIssue < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :pincode, :integer
    add_column :issues, :city, :string
  end
end
