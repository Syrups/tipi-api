class AddDurationToApiComments < ActiveRecord::Migration
  def change
  	add_column :api_comments, :duration, :integer
  end
end
