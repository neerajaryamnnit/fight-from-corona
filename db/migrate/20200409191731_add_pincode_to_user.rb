class AddPincodeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pincode, :string
    add_column :users, :thana, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :language, :string
  end
end
