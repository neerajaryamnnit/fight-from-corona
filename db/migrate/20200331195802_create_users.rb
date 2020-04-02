class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobile
      t.float :lat
      t.float :long
      t.string :password
      t.string :otp
      t.datetime :otp_verified_at
      t.string :temp_token

      t.timestamps
    end
  end
end
