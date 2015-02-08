class CreateApiUsers < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
      t.string :username
      t.string :password
      t.string :salt
      t.string :token
      t.datetime :last_request
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
