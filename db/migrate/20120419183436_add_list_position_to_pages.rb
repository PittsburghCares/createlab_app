class AddListPositionToPages < ActiveRecord::Migration
  def self.up
    add_column "pages", "list_position", :smallint
  end

  def self.down
    remove_column "pages", "list_position"
  end
end
