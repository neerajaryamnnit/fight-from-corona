class CreateSmsRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_requests do |t|
      t.string :message
      t.string :phone
      t.string :response
      t.string :response_code
      t.string :request_url
      t.timestamps
    end
  end
end
