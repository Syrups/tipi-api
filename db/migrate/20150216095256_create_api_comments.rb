class CreateApiComments < ActiveRecord::Migration
  def change
    create_table :api_comments do |t|
      t.references :page
      t.references :audio

      t.timestamps null: false
    end
  end
end
