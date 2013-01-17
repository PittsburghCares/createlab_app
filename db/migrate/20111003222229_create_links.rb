class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :event_id
      t.text :link
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
