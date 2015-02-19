class CreateJoinTableRoomStory < ActiveRecord::Migration
  def change
    create_join_table :stories, :rooms do |t|
      # t.index [:api_story_id, :api_room_id]
      # t.index [:api_room_id, :api_story_id]
    end
  end
end
