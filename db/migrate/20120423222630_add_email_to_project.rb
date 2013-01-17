class AddEmailToProject < ActiveRecord::Migration
  def self.up
    add_column "projects", "email", :text
  end

  def self.down
    remove_column "projects", "email"
  end
end
