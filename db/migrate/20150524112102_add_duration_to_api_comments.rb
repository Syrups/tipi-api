class AddDurationToApiComments < ActiveRecord::Migration
  def change
  	add_column :api_users, :duration, :integer
  end
end
