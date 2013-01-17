class CreatePageWebLinks < ActiveRecord::Migration
  def self.up
    create_table :page_web_links do |t|
      t.integer :page_id
      t.text :label
      t.text :link
      t.timestamps
    end
  end

  def self.down
    drop_table :page_web_links
  end
end
