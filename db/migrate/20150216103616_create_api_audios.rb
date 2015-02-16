class CreateApiAudios < ActiveRecord::Migration
  def change
    create_table :api_audios do |t|
      t.string :file
      t.integer :duration

      t.timestamps null: false
    end
  end
end
