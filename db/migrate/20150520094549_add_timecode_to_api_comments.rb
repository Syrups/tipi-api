class AddTimecodeToApiComments < ActiveRecord::Migration
  def change
  	add_column :api_comments, :timecode, :integer
  end
end
