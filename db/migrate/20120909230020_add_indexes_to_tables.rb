class AddIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :project_web_links, :project_id
    add_index :project_images, :project_id
    add_index :pages, :project_id
    add_index :page_web_links, :page_id
    add_index :page_images, :page_id
    add_index :events, :page_id
    add_index :pages_funders, [:page_id, :funder_id]
    add_index :users_events, [:user_id, :event_id]
    add_index :users_projects, [:user_id, :project_id]
    add_index :users_roles, [:user_id, :role_id]
  end

  def self.down
    remove_index :project_web_links, :project_id
    remove_index :project_images, :project_id
    remove_index :pages, :project_id
    remove_index :page_web_links, :page_id
    remove_index :page_images, :page_id
    remove_index :events, :page_id
    remove_index :pages_funders, [:page_id, :funder_id]
    remove_index :users_events, [:user_id, :event_id]
    remove_index :users_projects, [:user_id, :project_id]
    remove_index :users_roles, [:user_id, :role_id]  
  end
end
