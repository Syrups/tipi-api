class AddDeviceTokenAndDeviceTypeToApiUsers < ActiveRecord::Migration
  def change
  	add_column :api_users, :device_token, :string
  	add_column :api_users, :device_type, :string
  end
end
