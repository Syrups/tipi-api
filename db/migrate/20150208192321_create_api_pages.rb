class CreateApiPages < ActiveRecord::Migration
  def change
    create_table :api_pages do |t|
      t.float :duration
      t.integer :position
      t.boolean :has_only_sound
      t.integer :story_id

      t.timestamps null: false
    end
  end
end
