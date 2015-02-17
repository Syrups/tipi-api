class AddPublishedToStories < ActiveRecord::Migration
  def change
  	add_column :api_stories, :published, :boolean, default: false
  end
end
