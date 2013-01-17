class CreateProjectWebLinks < ActiveRecord::Migration
  def self.up
    create_table :project_web_links do |t|
      t.integer :project_id
      t.text :label
      t.text :link
      t.timestamps
    end
  end

  def self.down
    drop_table :project_web_links
  end
end
