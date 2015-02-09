class CreateApiReceptions < ActiveRecord::Migration
  def change
    create_table :api_receptions do |t|
      t.datetime :received_at
      t.boolean :acknowledged
      t.integer :story_id
      t.integer :receiver_id

      t.timestamps null: false
    end
  end
end
