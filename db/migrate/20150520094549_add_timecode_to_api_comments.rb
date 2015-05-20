class AddTimecodeToApiComments < ActiveRecord::Migration
  def change
  	add_column :api_users, :timecode, :integer
  end
end
