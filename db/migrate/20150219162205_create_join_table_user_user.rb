class CreateJoinTableUserUser < ActiveRecord::Migration
  def change
    create_join_table :users, :users do |t|
      # t.index [:user_id, :user_id]
      # t.index [:user_id, :user_id]
    end
  end
end
