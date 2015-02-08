class CreateApiSubscribtions < ActiveRecord::Migration
  def change
    create_table :api_subscribtions do |t|
      t.datetime :invited_at
      t.datetime :subscribed_at
      t.boolean :active
      t.integer :user_id
      t.integer :subscriber_id

      t.timestamps null: false
    end
  end
end
