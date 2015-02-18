class CreateApiUserDevices < ActiveRecord::Migration
  def change
    create_table :api_user_devices do |t|
      t.string :token
      t.integer :user_id
      t.string :platform

      t.timestamps null: false
    end
  end
end
