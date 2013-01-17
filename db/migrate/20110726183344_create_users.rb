class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string		:first_name,			:default => nil
      t.string		:last_name,			:default => nil
      t.string		:email
      t.string   	:login,                         :limit => 40
      t.string   	:crypted_password,              :limit => 40
      t.string   	:salt,                          :limit => 40
      t.string   	:remember_token,                :limit => 40
      t.datetime 	:remember_token_expires_at
      t.string          :password_reset_code,           :limit => 40
      t.string   	:activation_code,               :limit => 40
      t.datetime 	:activated_at,			:default => nil
      t.boolean 	:is_deleted,                    :default => false
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
