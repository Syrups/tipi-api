class AddAudioIdToUsers < ActiveRecord::Migration
  def change
  	add_column :api_users, :audio_id, :integer
  end
end
