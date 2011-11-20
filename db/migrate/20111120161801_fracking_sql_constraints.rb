class FrackingSqlConstraints < ActiveRecord::Migration
  def up
    # in one batch, delete the old indexes
    change_table :users do |t|
      t.remove_index :email
      t.remove_index :instagram_user_id
      t.remove_index :instagram_username
    end
    
    # then add the new, less constraining ones
    change_table :users do |t|
      t.change :email, :string, :null => true
      
      t.index :email
      t.index :instagram_user_id
      t.index :instagram_username
    end
  end
  
  def down
    # in one batch, delete the new indexes
    change_table :users do |t|
      t.remove_index :email
      t.remove_index :instagram_user_id
      t.remove_index :instagram_username
    end
    
    # then add the old, more constraining ones
    change_table :users do |t|
      t.change :email, :string, :null => false
      
      t.index :email, :unique => true
      t.index :instagram_user_id, :unique => true
      t.index :instagram_username, :unique => true
    end
  end
end
