class CreateApiPresences < ActiveRecord::Migration
  def change
    create_table :api_presences do |t|
    	t.boolean :active, default: false
    	t.integer :room_id
    	t.integer :user_id

    	t.timestamps null: false
    end
  end
end
