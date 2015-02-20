class AddTagToStories < ActiveRecord::Migration
  def change
  	add_column :api_stories, :tag, :string
  end
end
