class AddUserToComments < ActiveRecord::Migration
  def change
  	add_column :api_comments, :user_id, :integer
  end
end
