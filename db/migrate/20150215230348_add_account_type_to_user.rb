class AddTypeToUser < ActiveRecord::Migration
  def change
  	add_column :api_users, :account_type, :string, default: 'basic'
  end
end
