class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.text :name
      t.text :description
      t.text :website
      t.boolean :has_outreach,  :default => true
      t.text :status
      t.boolean :is_published,  :default => false
      t.boolean :is_deleted,    :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
