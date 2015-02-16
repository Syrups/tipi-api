class AddPageIdAndCommentIdToAudios < ActiveRecord::Migration
  def change
  	add_column :api_audios, :page_id, :integer
  	add_column :api_audios, :comment_id, :integer
  end
end
