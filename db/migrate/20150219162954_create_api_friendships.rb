class CreateApiFriendships < ActiveRecord::Migration
  def change
    create_table :api_friendships do |t|
      t.boolean :active, default: false
      t.integer :user_id
      t.integer :friend_id

      t.timestamps null: false
    end
  end
end
