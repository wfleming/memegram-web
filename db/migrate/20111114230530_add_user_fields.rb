class AddUserFields < ActiveRecord::Migration
  def up
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

  def down
    change_table :users do |t|
      t.remove :instagram_user_id
      t.remove :instagram_username
      t.remove :instagram_token
      t.remove :instagram_avatar_url
      t.remove :api_token
      t.remove :is_admin
    end
  end
end
