class AddPictoToApiRooms < ActiveRecord::Migration
  def change
  	add_column :api_rooms, :picto, :integer, default: 0
  end
end
