class CreateApiRooms < ActiveRecord::Migration
  def change
    create_table :api_rooms do |t|
      t.integer :owner_id
      t.string :name

      t.timestamps null: false
    end
  end
end
