class CreateApiMedia < ActiveRecord::Migration
  def change
    create_table :api_media do |t|
      t.string :file
      t.references :page
      t.string :type

      t.timestamps null: false
    end
  end
end
