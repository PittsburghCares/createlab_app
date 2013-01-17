class CreateUsersEvents < ActiveRecord::Migration
  def self.up
    create_table :users_events, :id => false do |t|
      t.references :user
      t.references :event
      t.timestamps
    end
  end

  def self.down
    drop_table :users_events
  end
end