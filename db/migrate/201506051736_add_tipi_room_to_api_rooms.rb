class AddTipiRoomToApiRooms < ActiveRecord::Migration
  def change
  	add_column :api_rooms, :tipi_room, :boolean
  end
end
