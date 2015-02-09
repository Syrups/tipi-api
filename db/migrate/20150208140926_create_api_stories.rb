class CreateApiStories < ActiveRecord::Migration
  def change
    create_table :api_stories do |t|
      t.datetime :created_at
      t.string :title
      t.integer :page_count
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
