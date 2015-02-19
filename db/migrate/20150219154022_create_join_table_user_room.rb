class CreateJoinTableUserRoom < ActiveRecord::Migration
  def change
    create_join_table :users, :rooms do |t|
      # t.index [:api_user_id, :api_room_id]
      # t.index [:api_room_id, :api_user_id]
    end
  end
end
