class AddUserFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :instagram_user_id
      t.index :instagram_user_id, :unique => true

      t.string :instagram_username
      t.index :instagram_username, :unique => true

      t.string :instagram_token
      t.index :instagram_token, :unique => true
      
      t.string :instagram_avatar_url

      t.string :api_token #auth token for internal API
      t.index :api_token, :unique => true

      t.boolean :is_admin, :default => false
      t.index :is_admin
    end
  end
end
