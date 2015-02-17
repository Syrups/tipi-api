class AddStoryTypeAndCandidateToStories < ActiveRecord::Migration
  def change
  	add_column :api_stories, :story_type, :string, default: 'private'
  	add_column :api_stories, :candidate, :boolean, default: false
  end
end
