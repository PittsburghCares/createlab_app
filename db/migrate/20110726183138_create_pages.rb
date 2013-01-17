class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :id, :integer
      t.column :name, :text
      t.column :project_id, :integer
      t.column :description, :text
      t.column :has_student_dialogues, :boolean, :default => false
      t.column :is_published, :boolean, :default => false
      t.column :is_deleted, :boolean, :default => false
      t.timestamps
    end
    create_table :pages_funders, :id => false do |t|
      t.integer :page_id
      t.integer :funder_id
    end
  end

  def self.down
    drop_table :pages
    drop_table :page_funders
  end
end
