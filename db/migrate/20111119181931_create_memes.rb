class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.references :user
      t.string :caption
      t.string :instagram_source_id
      t.string :instagram_source_link
      t.string :s3_resource_url
      t.timestamps
    end
  end
end
