class AddOtpToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :otp_created_at, :datetime
  end
end
