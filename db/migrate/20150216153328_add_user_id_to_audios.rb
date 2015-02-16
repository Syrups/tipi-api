class AddUserIdToAudios < ActiveRecord::Migration
  def change
  	add_column :api_audios, :user_id, :integer
  end
end
